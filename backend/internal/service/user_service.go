package service

import (
	"context"

	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
	"github.com/xiaohei7529/green-recycle/backend/internal/model"
)

// UserService 用户服务
type UserService struct {
	db  *gorm.DB
	rdb *redis.Client
}

// NewUserService 创建用户服务
func NewUserService(db *gorm.DB, rdb *redis.Client) *UserService {
	return &UserService{
		db:  db,
		rdb: rdb,
	}
}

// GetByID 根据 ID 获取用户
func (s *UserService) GetByID(ctx context.Context, userID uint) (*model.User, error) {
	var user model.User
	if err := s.db.First(&user, userID).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

// UpdateProfile 更新用户资料
func (s *UserService) UpdateProfile(ctx context.Context, userID uint, nickname, avatar string) error {
	return s.db.Model(&model.User{}).Where("id = ?", userID).Updates(map[string]interface{}{
		"nickname": nickname,
		"avatar":   avatar,
	}).Error
}

// GetBalance 获取用户余额
func (s *UserService) GetBalance(ctx context.Context, userID uint) (float64, error) {
	var user model.User
	if err := s.db.First(&user, userID).Error; err != nil {
		return 0, err
	}
	return user.Balance, nil
}

// GetPoints 获取用户积分
func (s *UserService) GetPoints(ctx context.Context, userID uint) (int, error) {
	var user model.User
	if err := s.db.First(&user, userID).Error; err != nil {
		return 0, err
	}
	return user.Points, nil
}
