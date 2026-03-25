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

	// TODO: 接入微信 OAuth2，用 req.Code 换取 openid，再关联/创建本地用户并签发 JWT
	// 参考：https://developers.weixin.qq.com/miniprogram/dev/OpenApiDoc/user-login/code2Session.html
	c.JSON(http.StatusNotImplemented, gin.H{
		"code":    501,
		"message": "微信登录功能尚未实现",
	})
}
