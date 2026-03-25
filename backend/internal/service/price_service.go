package service

import (
	"time"

	"gorm.io/gorm"
)

// PriceService 价格服务
type PriceService struct {
	db *gorm.DB
}

// NewPriceService 创建价格服务
func NewPriceService(db *gorm.DB) *PriceService {
	return &PriceService{
		db: db,
	}
}

// PriceCategory 价格分类
type PriceCategory struct {
	Name  string      `json:"name"`
	Items []PriceItem `json:"items"`
}

// PriceItem 价格项目
type PriceItem struct {
	Name    string  `json:"name"`
	Price   float64 `json:"price"`
	Unit    string  `json:"unit"`
	Updated string  `json:"updated"`
}

// dbPriceRow 用于接收 JOIN 查询结果
type dbPriceRow struct {
	CategoryName string
	Name         string
	Price        float64
	Unit         string
	UpdatedAt    time.Time
}

// ListPrices 从数据库获取价格列表，按分类分组返回
func (s *PriceService) ListPrices(category string) ([]PriceCategory, string, error) {
	var rows []dbPriceRow

	query := s.db.Table("prices p").
		Select("c.name AS category_name, p.name, p.price, p.unit, p.updated_at").
		Joins("JOIN categories c ON p.category_id = c.id").
		Where("c.status = ?", 1).
		Order("c.sort ASC, c.id ASC, p.id ASC")

	if category != "" && category != "all" {
		query = query.Where("c.name = ?", category)
	}

	if err := query.Scan(&rows).Error; err != nil {
		return nil, "", err
	}

	// 数据库暂无数据时返回初始化 mock，避免前端空白
	if len(rows) == 0 {
		return mockPrices(category)
	}

	// 按分类聚合，保持查询返回的顺序
	categoryMap := make(map[string]*PriceCategory)
	var categoryOrder []string
	latestUpdated := ""

	for _, r := range rows {
		if _, exists := categoryMap[r.CategoryName]; !exists {
			categoryMap[r.CategoryName] = &PriceCategory{Name: r.CategoryName}
			categoryOrder = append(categoryOrder, r.CategoryName)
		}
		updated := r.UpdatedAt.Format("2006-01-02 15:04:05")
		if latestUpdated == "" {
			latestUpdated = updated
		}
		categoryMap[r.CategoryName].Items = append(categoryMap[r.CategoryName].Items, PriceItem{
			Name:    r.Name,
			Price:   r.Price,
			Unit:    r.Unit,
			Updated: updated,
		})
	}

	if latestUpdated == "" {
		latestUpdated = time.Now().Format("2006-01-02 15:04:05")
	}

	result := make([]PriceCategory, 0, len(categoryOrder))
	for _, name := range categoryOrder {
		result = append(result, *categoryMap[name])
	}

	return result, latestUpdated, nil
}

// mockPrices 当数据库尚未初始化数据时使用的兜底数据
func mockPrices(category string) ([]PriceCategory, string, error) {
	updatedAt := time.Now().Format("2006-01-02 15:04:05")

	categories := []PriceCategory{
		{
			Name: "纸类",
			Items: []PriceItem{
				{Name: "报纸", Price: 1.5, Unit: "kg", Updated: updatedAt},
				{Name: "纸箱", Price: 1.2, Unit: "kg", Updated: updatedAt},
				{Name: "书本", Price: 1.8, Unit: "kg", Updated: updatedAt},
			},
		},
		{
			Name: "塑料",
			Items: []PriceItem{
				{Name: "PET 瓶", Price: 2.0, Unit: "kg", Updated: updatedAt},
				{Name: "PE 膜", Price: 3.5, Unit: "kg", Updated: updatedAt},
				{Name: "PP 塑料", Price: 4.0, Unit: "kg", Updated: updatedAt},
			},
		},
		{
			Name: "金属",
			Items: []PriceItem{
				{Name: "铁", Price: 3.5, Unit: "kg", Updated: updatedAt},
				{Name: "铝", Price: 12.0, Unit: "kg", Updated: updatedAt},
				{Name: "铜", Price: 45.0, Unit: "kg", Updated: updatedAt},
			},
		},
		{
			Name: "电器",
			Items: []PriceItem{
				{Name: "空调", Price: 150.0, Unit: "台", Updated: updatedAt},
				{Name: "冰箱", Price: 100.0, Unit: "台", Updated: updatedAt},
				{Name: "洗衣机", Price: 80.0, Unit: "台", Updated: updatedAt},
			},
		},
	}

	if category != "" && category != "all" {
		for _, cat := range categories {
			if cat.Name == category {
				return []PriceCategory{cat}, updatedAt, nil
			}
		}
		return []PriceCategory{}, updatedAt, nil
	}

	return categories, updatedAt, nil
}
