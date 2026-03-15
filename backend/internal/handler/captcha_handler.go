package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/xiaohei7529/green-recycle/backend/internal/service"
)

// CaptchaHandler 验证码处理器
type CaptchaHandler struct {
	captchaService *service.CaptchaService
}

// NewCaptchaHandler 创建验证码处理器
func NewCaptchaHandler(captchaService *service.CaptchaService) *CaptchaHandler {
	return &CaptchaHandler{
		captchaService: captchaService,
	}
}

// GenerateCaptcha 生成图形验证码
// GET /api/v1/captcha/:captchaID
func (h *CaptchaHandler) GenerateCaptcha(c *gin.Context) {
	captchaID := c.Param("captchaID")
	if captchaID == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "验证码 ID 不能为空",
		})
		return
	}

	// 生成验证码
	imgBase64, err := h.captchaService.Generate(c.Request.Context(), captchaID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "生成验证码失败：" + err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "生成成功",
		"data": gin.H{
			"captcha_id": captchaID,
			"image":      imgBase64,
			"expires_in": 300, // 5 分钟
		},
	})
}

// VerifyCaptcha 验证图形验证码
// POST /api/v1/captcha/verify
func (h *CaptchaHandler) VerifyCaptcha(c *gin.Context) {
	var req struct {
		CaptchaID string `json:"captcha_id" binding:"required"`
		Code      string `json:"code" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "请求参数错误：" + err.Error(),
		})
		return
	}

	if err := h.captchaService.Verify(c.Request.Context(), req.CaptchaID, req.Code); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "验证成功",
	})
}

// SendSMSCode 发送短信验证码
// POST /api/v1/sms/send
func (h *CaptchaHandler) SendSMSCode(c *gin.Context) {
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

	// 检查冷却时间
	cooldown, err := h.captchaService.GetSMSCodeCooldown(c.Request.Context(), req.Phone)
	if err == nil && cooldown > 0 {
		c.JSON(http.StatusTooManyRequests, gin.H{
			"code":    429,
			"message": "操作过于频繁，请稍后再试",
			"data": gin.H{
				"cooldown": cooldown,
			},
		})
		return
	}

	// 发送验证码
	_, err = h.captchaService.SendSMSCode(c.Request.Context(), req.Phone)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "发送验证码失败：" + err.Error(),
		})
		return
	}

	// 设置冷却时间（60 秒）
	h.captchaService.SetSMSCodeCooldown(c.Request.Context(), req.Phone, 60)

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "验证码已发送",
		"data": gin.H{
			"expires_in": 300, // 5 分钟
		},
	})
}

// VerifySMSCode 验证短信验证码
// POST /api/v1/sms/verify
func (h *CaptchaHandler) VerifySMSCode(c *gin.Context) {
	var req struct {
		Phone string `json:"phone" binding:"required,len=11"`
		Code  string `json:"code" binding:"required,len=6"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": "请求参数错误：" + err.Error(),
		})
		return
	}

	if err := h.captchaService.VerifySMSCode(c.Request.Context(), req.Phone, req.Code); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code":    400,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "验证成功",
	})
}
