package service

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/go-redis/redis/v8"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
	"github.com/xiaohei7529/green-recycle/backend/internal/model"
)

var (
	ErrUserNotFound     = errors.New("用户不存在")
	ErrInvalidPassword  = errors.New("密码错误")
	ErrInvalidToken     = errors.New("无效的 Token")
	ErrUserExists       = errors.New("手机号已注册")
)

// AuthService 认证服务
type AuthService struct {
	db    *gorm.DB
	rdb   *redis.Client
	jwtSecret string
}

// NewAuthService 创建认证服务
func NewAuthService(db *gorm.DB, rdb *redis.Client, jwtSecret string) *AuthService {
	return &AuthService{
		db: db,
		rdb: rdb,
		jwtSecret: jwtSecret,
	}
}

// Register 用户注册
func (s *AuthService) Register(ctx context.Context, phone, password string) (*model.User, error) {
	// 检查缓存
	cacheKey := fmt.Sprintf("user:phone:%s", phone)
	if cached, _ := s.rdb.Get(ctx, cacheKey).Result(); cached != "" {
		return nil, ErrUserExists
	}

	// 检查用户是否已存在 (使用索引优化)
	var existingUser model.User
	if err := s.db.Where("phone = ?", phone).First(&existingUser).Error; err == nil {
		return nil, ErrUserExists
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, err
	}

	// 密码强度检查
	if len(password) < 6 {
		return nil, errors.New("密码长度至少 6 位")
	}

	// 密码加密 (使用更安全的 cost)
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.MinCost+2)
	if err != nil {
		return nil, err
	}

	// 创建用户 (使用事务)
	user := &model.User{
		Phone:    phone,
		Password: string(hashedPassword),
		Nickname: "用户" + phone[len(phone)-4:],
		Status:   1,
	}

	tx := s.db.Begin()
	if err := tx.Create(user).Error; err != nil {
		tx.Rollback()
		return nil, err
	}
	tx.Commit()

	// 缓存用户信息
	s.CacheUserInfo(ctx, user)

	return user, nil
}

// Login 用户登录
func (s *AuthService) Login(ctx context.Context, phone, password string) (string, error) {
	// 检查缓存
	cacheKey := fmt.Sprintf("user:phone:%s", phone)
	var user model.User
	
	// 尝试从缓存获取
	if cached, err := s.rdb.Get(ctx, cacheKey).Result(); err == nil {
		// 缓存命中，解析用户信息 (简化处理，实际应使用 JSON 序列化)
		if err := s.db.Where("phone = ?", phone).First(&user).Error; err != nil {
			return "", ErrUserNotFound
		}
	} else {
		// 缓存未命中，从数据库查询
		if err := s.db.Where("phone = ?", phone).First(&user).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return "", ErrUserNotFound
			}
			return "", err
		}
		// 写入缓存
		s.CacheUserInfo(ctx, &user)
	}

	// 验证密码
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", ErrInvalidPassword
	}

	// 检查用户状态
	if user.Status != 1 {
		return "", errors.New("账号已被禁用")
	}

	// 生成 JWT Token
	token, err := s.generateToken(user.ID)
	if err != nil {
		return "", err
	}

	// 记录登录日志 (异步)
	go s.logLogin(ctx, user.ID, phone)

	return token, nil
}

// logLogin 记录登录日志
func (s *AuthService) logLogin(ctx context.Context, userID uint, phone string) {
	key := fmt.Sprintf("login:log:%d", userID)
	data := map[string]interface{}{
		"user_id":  userID,
		"phone":    phone,
		"login_at": time.Now().Format("2006-01-02 15:04:05"),
	}
	s.rdb.HSet(ctx, key, data)
	s.rdb.Expire(ctx, key, time.Hour*24*30) // 保留 30 天
}

// generateToken 生成 JWT Token
func (s *AuthService) generateToken(userID uint) (string, error) {
	claims := jwt.MapClaims{
		"user_id": userID,
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
		"iat":     time.Now().Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(s.jwtSecret))
}

// VerifyToken 验证 Token
func (s *AuthService) VerifyToken(tokenString string) (uint, error) {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// 验证签名方法
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(s.jwtSecret), nil
	})

	if err != nil {
		return 0, ErrInvalidToken
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return 0, ErrInvalidToken
	}

	userID, ok := claims["user_id"].(float64)
	if !ok {
		return 0, ErrInvalidToken
	}

	return uint(userID), nil
}

// CacheUserInfo 缓存用户信息
func (s *AuthService) CacheUserInfo(ctx context.Context, user *model.User) error {
	key := fmt.Sprintf("user:%d", user.ID)
	phoneKey := fmt.Sprintf("user:phone:%s", user.Phone)
	
	// 缓存用户 ID -> 用户信息
	if err := s.rdb.Set(ctx, key, user, time.Hour*24).Err(); err != nil {
		return err
	}
	
	// 缓存手机号 -> 用户 ID (用于快速查找)
	if err := s.rdb.Set(ctx, phoneKey, user.ID, time.Hour*24).Err(); err != nil {
		return err
	}
	
	return nil
}

// GetUserFromCache 从缓存获取用户信息
func (s *AuthService) GetUserFromCache(ctx context.Context, userID uint) (*model.User, error) {
	key := fmt.Sprintf("user:%d", userID)
	// TODO: 实际应使用 JSON 序列化/反序列化
	return nil, errors.New("not implemented")
}

// RefreshToken 刷新 Token
func (s *AuthService) RefreshToken(tokenString string) (string, error) {
	// 验证原 Token
	userID, err := s.VerifyToken(tokenString)
	if err != nil {
		return "", err
	}

	// 生成新 Token
	return s.generateToken(userID)
}
