package model

import (
	"time"
)

// User 用户模型
type User struct {
	ID        uint      `gorm:"primary_key" json:"user_id"`
	Phone     string    `gorm:"uniqueIndex;size:11;not null" json:"phone"`
	Password  string    `gorm:"size:255;not null" json:"-"`
	Nickname  string    `gorm:"size:50" json:"nickname"`
	Avatar    string    `gorm:"size:255" json:"avatar"`
	Points    int       `gorm:"default:0" json:"points"`
	Status    int       `gorm:"default:1" json:"status"` // 1:正常 0:禁用
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// TableName 指定表名
func (User) TableName() string {
	return "users"
}

// UserLoginRequest 用户登录请求
type UserLoginRequest struct {
	Phone    string `json:"phone" binding:"required,len=11"`
	Password string `json:"password" binding:"required,min=6"`
}

// UserRegisterRequest 用户注册请求
type UserRegisterRequest struct {
	Phone    string `json:"phone" binding:"required,len=11"`
	Code     string `json:"code" binding:"required,len=6"`
	Password string `json:"password" binding:"required,min=6"`
}

// UserProfileResponse 用户信息响应
type UserProfileResponse struct {
	UserID      uint   `json:"user_id"`
	Phone       string `json:"phone"`
	Nickname    string `json:"nickname"`
	Avatar      string `json:"avatar"`
	Points      int    `json:"points"`
	TotalOrders int    `json:"total_orders"`
	TotalIncome string `json:"total_income"`
}
