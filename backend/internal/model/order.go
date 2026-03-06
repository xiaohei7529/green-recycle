package model

import (
	"time"
)

// Order 订单模型
type Order struct {
	ID              uint      `gorm:"primary_key" json:"order_id"`
	OrderNo         string    `gorm:"uniqueIndex;size:32;not null" json:"order_no"`
	UserID          uint      `gorm:"index;not null" json:"user_id"`
	RecyclerID      uint      `gorm:"index" json:"recycler_id"`
	Type            int       `gorm:"not null" json:"type"` // 1:上门回收 2:站点回收
	Status          int       `gorm:"default:0" json:"status"` // 0:待接单 1:已接单 2:回收中 3:已完成 4:已取消
	TotalAmount     float64   `gorm:"type:decimal(10,2)" json:"total_amount"`
	TotalWeight     float64   `gorm:"type:decimal(10,2)" json:"total_weight"`
	Province        string    `gorm:"size:50" json:"province"`
	City            string    `gorm:"size:50" json:"city"`
	District        string    `gorm:"size:50" json:"district"`
	Address         string    `gorm:"size:255;not null" json:"address"`
	ContactName     string    `gorm:"size:50;not null" json:"contact_name"`
	ContactPhone    string    `gorm:"size:11;not null" json:"contact_phone"`
	PickupTime      time.Time `json:"pickup_time"`
	CompletedAt     *time.Time `json:"completed_at"`
	CancelledAt     *time.Time `json:"cancelled_at"`
	Remark          string    `gorm:"size:255" json:"remark"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
	
	// 关联
	User       *User       `gorm:"foreignKey:UserID" json:"user,omitempty"`
	Recycler   *User       `gorm:"foreignKey:RecyclerID" json:"recycler,omitempty"`
	OrderItems []OrderItem `gorm:"foreignKey:OrderID" json:"order_items,omitempty"`
}

// TableName 指定表名
func (Order) TableName() string {
	return "orders"
}

// OrderItem 订单物品明细
type OrderItem struct {
	ID         uint    `gorm:"primary_key" json:"id"`
	OrderID    uint    `gorm:"index;not null" json:"order_id"`
	CategoryID uint    `gorm:"index;not null" json:"category_id"`
	Category   string  `gorm:"size:50;not null" json:"category"`
	Weight     float64 `gorm:"type:decimal(10,2);not null" json:"weight"`
	Price      float64 `gorm:"type:decimal(10,2);not null" json:"price"`
	Amount     float64 `gorm:"type:decimal(10,2);not null" json:"amount"`
}

// TableName 指定表名
func (OrderItem) TableName() string {
	return "order_items"
}

// CreateOrderRequest 创建订单请求
type CreateOrderRequest struct {
	Type       int              `json:"type" binding:"required,oneof=1 2"`
	Items      []OrderItemInput `json:"items" binding:"required,min=1"`
	Address    AddressInput     `json:"address" binding:"required"`
	Contact    ContactInput     `json:"contact" binding:"required"`
	PickupTime string           `json:"pickup_time" binding:"required"`
	Remark     string           `json:"remark"`
}

// OrderItemInput 订单物品输入
type OrderItemInput struct {
	Category string  `json:"category" binding:"required"`
	Weight   float64 `json:"weight" binding:"required,min=0.1"`
	Price    float64 `json:"price" binding:"required,min=0"`
}

// AddressInput 地址输入
type AddressInput struct {
	Province string `json:"province" binding:"required"`
	City     string `json:"city" binding:"required"`
	District string `json:"district" binding:"required"`
	Detail   string `json:"detail" binding:"required"`
}

// ContactInput 联系人输入
type ContactInput struct {
	Name  string `json:"name" binding:"required"`
	Phone string `json:"phone" binding:"required,len=11"`
}
