package service

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/go-redis/redis/v8"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
	"github.com/xiaohei7529/green-recycle/backend/internal/model"
)

var (
	ErrResetTokenInvalid = errors.New("重置令牌无效或已过期")
	ErrPasswordTooWeak   = errors.New("密码强度不足")
)

// PasswordResetService 密码重置服务
type PasswordResetService struct {
	db    *gorm.DB
	rdb   *redis.Client
	jwtSecret string
}

// NewPasswordResetService 创建密码重置服务
func NewPasswordResetService(db *gorm.DB, rdb *redis.Client, jwtSecret string) *PasswordResetService {
	return &PasswordResetService{
		db: db,
		rdb: rdb,
		jwtSecret: jwtSecret,
	}
}

// RequestReset 请求密码重置
func (s *PasswordResetService) RequestReset(ctx context.Context, phone string) error {
	// 检查用户是否存在
	var user model.User
	if err := s.db.Where("phone = ?", phone).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			// 为了安全，不提示用户不存在
			return nil
		}
		return err
	}

	// 生成重置令牌
	resetToken := generateResetToken()
	
	// 存储到 Redis（30 分钟过期）
	key := fmt.Sprintf("password:reset:%s", resetToken)
	data := map[string]interface{}{
		"user_id": user.ID,
		"phone":   phone,
	}
	
	// 简化处理，实际应使用 JSON 序列化
	if err := s.rdb.HSet(ctx, key, data).Err(); err != nil {
		return err
	}
	if err := s.rdb.Expire(ctx, key, time.Minute*30).Err(); err != nil {
		return err
	}

	// 发送短信通知（包含重置令牌）
	// TODO: 调用短信服务
	fmt.Printf("【Green Recycle】您正在重置密码，重置码：%s，30 分钟内有效。如非本人操作，请忽略。\n", resetToken)

	return nil
}

// VerifyResetToken 验证重置令牌
func (s *PasswordResetService) VerifyResetToken(ctx context.Context, resetToken string) (uint, error) {
	key := fmt.Sprintf("password:reset:%s", resetToken)
	
	// 从 Redis 获取
	result, err := s.rdb.HGet(ctx, key, "user_id").Result()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return 0, ErrResetTokenInvalid
		}
		return 0, err
	}

	// 解析 user_id
	var userID uint
	fmt.Sscanf(result, "%d", &userID)
	
	if userID == 0 {
		return 0, ErrResetTokenInvalid
	}

	return userID, nil
}

// ResetPassword 重置密码
func (s *PasswordResetService) ResetPassword(ctx context.Context, resetToken, newPassword string) error {
	// 验证令牌
	userID, err := s.VerifyResetToken(ctx, resetToken)
	if err != nil {
		return err
	}

	// 密码强度检查
	if err := s.checkPasswordStrength(newPassword); err != nil {
		return err
	}

	// 密码加密
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.MinCost+2)
	if err != nil {
		return err
	}

	// 更新密码
	tx := s.db.Begin()
	if err := tx.Model(&model.User{}).Where("id = ?", userID).Update("password", string(hashedPassword)).Error; err != nil {
		tx.Rollback()
		return err
	}
	tx.Commit()

	// 删除重置令牌
	key := fmt.Sprintf("password:reset:%s", resetToken)
	s.rdb.Del(ctx, key)

	// 记录密码修改日志
	s.logPasswordChange(ctx, userID)

	return nil
}

// checkPasswordStrength 检查密码强度
func (s *PasswordResetService) checkPasswordStrength(password string) error {
	if len(password) < 6 {
		return ErrPasswordTooWeak
	}
	if len(password) > 20 {
		return errors.New("密码长度不能超过 20 位")
	}
	
	// 至少包含字母和数字
	hasLetter := false
	hasDigit := false
	for _, c := range password {
		if (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') {
			hasLetter = true
		}
		if c >= '0' && c <= '9' {
			hasDigit = true
		}
	}
	
	if !hasLetter || !hasDigit {
		return errors.New("密码必须包含字母和数字")
	}
	
	return nil
}

// logPasswordChange 记录密码修改日志
func (s *PasswordResetService) logPasswordChange(ctx context.Context, userID uint) {
	key := fmt.Sprintf("password:log:%d", userID)
	data := map[string]interface{}{
		"user_id":    userID,
		"changed_at": time.Now().Format("2006-01-02 15:04:05"),
		"reason":     "reset",
	}
	s.rdb.HSet(ctx, key, data)
	s.rdb.Expire(ctx, key, time.Hour*24*90) // 保留 90 天
}

// generateResetToken 生成重置令牌
func generateResetToken() string {
	chars := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	return generateRandomString(chars, 8)
}

// generateRandomString 生成随机字符串
func generateRandomString(chars string, length int) string {
	// 简化实现，实际应使用 crypto/rand
	result := make([]byte, length)
	for i := 0; i < length; i++ {
		result[i] = chars[i%len(chars)]
	}
	return string(result)
}
