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
	Name  string       `json:"name"`
	Items []PriceItem  `json:"items"`
}

// PriceItem 价格项目
type PriceItem struct {
	Name     string  `json:"name"`
	Price    float64 `json:"price"`
	Unit     string  `json:"unit"`
	Updated  string  `json:"updated"`
}

// ListPrices 获取价格列表
func (s *PriceService) ListPrices(category string) ([]PriceCategory, string, error) {
	// TODO: 从数据库读取价格
	// 这里使用模拟数据

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

	if category != "all" {
		for _, cat := range categories {
			if cat.Name == category {
				return []PriceCategory{cat}, updatedAt, nil
			}
		}
		return []PriceCategory{}, updatedAt, nil
	}

	return categories, updatedAt, nil
}
