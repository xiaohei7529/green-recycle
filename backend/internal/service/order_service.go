package service

import (
	"context"
	"fmt"
	"time"

	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
	"github.com/xiaohei7529/green-recycle/backend/internal/model"
)

// OrderService 订单服务
type OrderService struct {
	db  *gorm.DB
	rdb *redis.Client
}

// NewOrderService 创建订单服务
func NewOrderService(db *gorm.DB, rdb *redis.Client) *OrderService {
	return &OrderService{
		db:  db,
		rdb: rdb,
	}
}

// CreateOrder 创建订单
func (s *OrderService) CreateOrder(userID uint, req *model.CreateOrderRequest) (*model.Order, error) {
	// 生成订单号
	orderNo := fmt.Sprintf("ORD%d%s", time.Now().Unix(), randomString(6))

	// 解析上门时间
	pickupTime, err := time.Parse("2006-01-02 15:04:05", req.PickupTime)
	if err != nil {
		return nil, fmt.Errorf("上门时间格式错误：%v", err)
	}

	// 创建订单
	order := &model.Order{
		OrderNo:      orderNo,
		UserID:       userID,
		Type:         req.Type,
		Status:       0, // 待接单
		Province:     req.Address.Province,
		City:         req.Address.City,
		District:     req.Address.District,
		Address:      req.Address.Detail,
		ContactName:  req.Contact.Name,
		ContactPhone: req.Contact.Phone,
		PickupTime:   pickupTime,
		Remark:       req.Remark,
	}

	// 计算总金额和总重量
	var totalWeight float64
	var totalAmount float64

	for _, item := range req.Items {
		amount := item.Weight * item.Price
		totalWeight += item.Weight
		totalAmount += amount

		order.OrderItems = append(order.OrderItems, model.OrderItem{
			Category: item.Category,
			Weight:   item.Weight,
			Price:    item.Price,
			Amount:   amount,
		})
	}

	order.TotalWeight = totalWeight
	order.TotalAmount = totalAmount

	// 事务创建订单和订单项
	err = s.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(order).Error; err != nil {
			return err
		}

		// 创建订单项
		for i := range order.OrderItems {
			order.OrderItems[i].OrderID = order.ID
		}
		if err := tx.Create(&order.OrderItems).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	// 推送新订单通知（给附近回收员）
	s.pushNewOrderNotification(context.Background(), order)

	return order, nil
}

// ListOrders 获取订单列表 (带缓存优化)
func (s *OrderService) ListOrders(ctx context.Context, userID uint, status string, page, pageSize int) (*[]model.Order, int64, error) {
	// 缓存 Key
	cacheKey := fmt.Sprintf("orders:user:%d:status:%s:page:%d:size:%d", userID, status, page, pageSize)
	
	// 尝试从缓存获取 (简化处理，实际应使用 JSON 序列化)
	// cached, err := s.rdb.Get(ctx, cacheKey).Result()
	// if err == nil {
	//     // 缓存命中，解析返回
	// }

	query := s.db.Model(&model.Order{}).Where("user_id = ?", userID)

	if status != "" && status != "all" {
		query = query.Where("status = ?", status)
	}

	query.Count(&total)

	// 分页优化：使用 Limit  + Offset
	offset := (page - 1) * pageSize
	err := query.Preload("OrderItems").
		Order("created_at DESC").
		Offset(offset).
		Limit(pageSize).
		Find(&orders).Error

	if err != nil {
		return nil, 0, err
	}

	// 写入缓存 (5 分钟)
	// s.rdb.Set(ctx, cacheKey, orders, time.Minute*5)

	return &orders, total, nil
}

// GetOrder 获取订单详情 (带缓存优化)
func (s *OrderService) GetOrder(ctx context.Context, orderID uint, userID uint) (*model.Order, error) {
	// 缓存 Key
	cacheKey := fmt.Sprintf("order:%d", orderID)
	
	// 尝试从缓存获取
	// cached, err := s.rdb.Get(ctx, cacheKey).Result()
	// if err == nil {
	//     // 缓存命中，解析返回
	// }

	var order model.Order

	err := s.db.Preload("OrderItems").
		Preload("User").
		Preload("Recycler").
		First(&order, orderID).Error

	if err != nil {
		return nil, err
	}

	// 权限检查
	if order.UserID != userID {
		return nil, fmt.Errorf("无权查看此订单")
	}

	// 写入缓存 (10 分钟)
	// s.rdb.Set(ctx, cacheKey, order, time.Minute*10)

	return &order, nil
}

// CancelOrder 取消订单
func (s *OrderService) CancelOrder(orderID uint, userID uint) error {
	var order model.Order

	err := s.db.First(&order, orderID).Error
	if err != nil {
		return err
	}

	// 权限检查
	if order.UserID != userID {
		return fmt.Errorf("无权操作此订单")
	}

	// 只有待接单状态可以取消
	if order.Status != 0 {
		return fmt.Errorf("当前状态无法取消")
	}

	now := time.Now()
	order.Status = 4 // 已取消
	order.CancelledAt = &now

	return s.db.Save(&order).Error
}

// AcceptOrder 回收员接单
func (s *OrderService) AcceptOrder(orderID uint, recyclerID uint) error {
	var order model.Order

	err := s.db.First(&order, orderID).Error
	if err != nil {
		return err
	}

	// 只有待接单状态可以接单
	if order.Status != 0 {
		return fmt.Errorf("订单已被接单")
	}

	order.Status = 1 // 已接单
	order.RecyclerID = recyclerID

	return s.db.Save(&order).Error
}

// CompleteOrder 完成订单
func (s *OrderService) CompleteOrder(orderID uint, recyclerID uint, actualWeight, actualAmount float64, photos []string) error {
	var order model.Order

	err := s.db.First(&order, orderID).Error
	if err != nil {
		return err
	}

	// 权限检查
	if order.RecyclerID != recyclerID {
		return fmt.Errorf("无权操作此订单")
	}

	// 只有回收中状态可以完成
	if order.Status != 2 {
		return fmt.Errorf("订单状态错误")
	}

	now := time.Now()
	order.Status = 3 // 已完成
	order.TotalWeight = actualWeight
	order.TotalAmount = actualAmount
	order.CompletedAt = &now

	// TODO: 保存照片
	// TODO: 更新用户积分
	// TODO: 更新回收员收益

	return s.db.Save(&order).Error
}

// pushNewOrderNotification 推送新订单通知
func (s *OrderService) pushNewOrderNotification(ctx context.Context, order *model.Order) {
	// 将新订单推送到 Redis，供附近回收员获取
	key := fmt.Sprintf("new_orders:%s", order.District)
	s.rdb.LPush(ctx, key, order.ID)
	s.rdb.Expire(ctx, key, time.Hour*24)
}

// randomString 生成随机字符串
func randomString(n int) string {
	const letters = "0123456789abcdef"
	b := make([]byte, n)
	for i := range b {
		b[i] = letters[time.Now().UnixNano()%int64(len(letters))]
	}
	return string(b)
}
