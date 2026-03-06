package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/xiaohei7529/green-recycle/backend/internal/service"
)

// AuthHandler 认证处理器
type AuthHandler struct {
	authService *service.AuthService
}

// NewAuthHandler 创建认证处理器
func NewAuthHandler(authService *service.AuthService) *AuthHandler {
	return &AuthHandler{
		authService: authService,
	}
}

// Register 用户注册
func (h *AuthHandler) Register(c *gin.Context) {
	var req struct {
		Phone    string `json:"phone" binding:"required,len=11"`
		Code     string `json:"code" binding:"required,len=6"`
		Password string `json:"password" binding:"required,min=6"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"code": 400, "message": "请求参数错误"})
		return
	}

	// TODO: 验证短信验证码

	user, err := h.authService.Register(req.Phone, req.Password)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"code": 400, "message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "注册成功",
		"data": gin.H{
			"user_id": user.ID,
			"phone":   user.Phone,
		},
	})
}

// Login 用户登录
func (h *AuthHandler) Login(c *gin.Context) {
	var req struct {
		Phone    string `json:"phone" binding:"required,len=11"`
		Password string `json:"password" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"code": 400, "message": "请求参数错误"})
		return
	}

	token, err := h.authService.Login(req.Phone, req.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"code": 401, "message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "登录成功",
		"data": gin.H{
			"token":      token,
			"expires_in": 86400,
		},
	})
}

// WechatLogin 微信登录
func (h *AuthHandler) WechatLogin(c *gin.Context) {
	var req struct {
		Code string `json:"code" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"code": 400, "message": "请求参数错误"})
		return
	}

	// TODO: 实现微信登录逻辑

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "微信登录成功",
		"data": gin.H{
			"token":      "wechat_token",
			"expires_in": 86400,
		},
	})
}
