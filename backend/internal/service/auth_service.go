package service

import (
	"context"
	"errors"
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
)

// AuthService 认证服务
type AuthService struct {
	db    *gorm.DB
	rdb   *redis.Client
	jwtSecret string
}

// NewAuthService 创建认证服务
func NewAuthService(db *gorm.DB, rdb *redis.Client) *AuthService {
	return &AuthService{
		db: db,
		rdb: rdb,
		jwtSecret: "your_jwt_secret_key", // 应该从配置文件读取
	}
}

// Register 用户注册
func (s *AuthService) Register(phone, password string) (*model.User, error) {
	// 检查用户是否已存在
	var existingUser model.User
	if err := s.db.Where("phone = ?", phone).First(&existingUser).Error; err == nil {
		return nil, errors.New("手机号已注册")
	}

	// 密码加密
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	// 创建用户
	user := &model.User{
		Phone:    phone,
		Password: string(hashedPassword),
		Nickname: "用户" + phone[len(phone)-4:],
		Status:   1,
	}

	if err := s.db.Create(user).Error; err != nil {
		return nil, err
	}

	return user, nil
}

// Login 用户登录
func (s *AuthService) Login(phone, password string) (string, error) {
	// 查找用户
	var user model.User
	if err := s.db.Where("phone = ?", phone).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return "", ErrUserNotFound
		}
		return "", err
	}

	// 验证密码
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", ErrInvalidPassword
	}

	// 生成 JWT Token
	token, err := s.generateToken(user.ID)
	if err != nil {
		return "", err
	}

	return token, nil
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
		return []byte(s.jwtSecret), nil
	})

	if err != nil {
		return 0, ErrInvalidToken
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return 0, ErrInvalidToken
	}

	userID := uint(claims["user_id"].(float64))
	return userID, nil
}

// CacheUserInfo 缓存用户信息
func (s *AuthService) CacheUserInfo(ctx context.Context, user *model.User) error {
	key := "user:" + string(rune(user.ID))
	return s.rdb.Set(ctx, key, user, time.Hour*24).Err()
}
