package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/xiaohei7529/green-recycle/backend/internal/service"
)

// PriceHandler 价格处理器
type PriceHandler struct {
	priceService *service.PriceService
}

// NewPriceHandler 创建价格处理器
func NewPriceHandler(priceService *service.PriceService) *PriceHandler {
	return &PriceHandler{
		priceService: priceService,
	}
}

// ListPrices 获取价格列表
func (h *PriceHandler) ListPrices(c *gin.Context) {
	category := c.DefaultQuery("category", "all")

	prices, updatedAt, err := h.priceService.ListPrices(category)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"code": 500, "message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "success",
		"data": gin.H{
			"updated_at": updatedAt,
			"categories": prices,
		},
	})
}
