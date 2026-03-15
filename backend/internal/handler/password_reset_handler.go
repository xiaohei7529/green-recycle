package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/xiaohei7529/green-recycle/backend/internal/service"
)

// PasswordResetHandler 密码重置处理器
type PasswordResetHandler struct {
	resetService *service.PasswordResetService
}

// NewPasswordResetHandler 创建密码重置处理器
func NewPasswordResetHandler(resetService *service.PasswordResetService) *PasswordResetHandler {
	return &PasswordResetHandler{
		resetService: resetService,
	}
}

// RequestReset 请求密码重置
// POST /api/v1/auth/password/reset/request
func (h *PasswordResetHandler) RequestReset(c *gin.Context) {
	var req struct {
		Phone string `json:"phone" binding:"required,len=11"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "请求参数错误：" + err.Error(),
		})
		return
	}

	if err := h.resetService.RequestReset(c.Request.Context(), req.Phone); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "请求失败：" + err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "重置链接已发送到手机",
		"data": gin.H{
			"expires_in": 1800, // 30 分钟
		},
	})
}

// VerifyResetToken 验证重置令牌
// POST /api/v1/auth/password/reset/verify
func (h *PasswordResetHandler) VerifyResetToken(c *gin.Context) {
	var req struct {
		ResetToken string `json:"reset_token" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "请求参数错误：" + err.Error(),
		})
		return
	}

	userID, err := h.resetService.VerifyResetToken(c.Request.Context(), req.ResetToken)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "验证成功",
		"data": gin.H{
			"user_id": userID,
		},
	})
}

// ResetPassword 重置密码
// POST /api/v1/auth/password/reset
func (h *PasswordResetHandler) ResetPassword(c *gin.Context) {
	var req struct {
		ResetToken  string `json:"reset_token" binding:"required"`
		NewPassword string `json:"new_password" binding:"required,min=6,max=20"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "请求参数错误：" + err.Error(),
		})
		return
	}

	if err := h.resetService.ResetPassword(c.Request.Context(), req.ResetToken, req.NewPassword); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "密码重置成功",
	})
}
