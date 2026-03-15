package service

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"fmt"
	"image"
	"image/color"
	"image/draw"
	"image/jpeg"
	"io"
	"math"
	"math/big"
	"strings"
	"sync"
	"time"

	"github.com/go-redis/redis/v8"
	"github.com/golang/freetype"
	"github.com/golang/freetype/truetype"
)

var (
	ErrCaptchaNotFound  = errors.New("验证码不存在或已过期")
	ErrCaptchaMismatch  = errors.New("验证码错误")
	ErrCaptchaExpired   = errors.New("验证码已过期")
)

// CaptchaService 验证码服务
type CaptchaService struct {
	rdb        *redis.Client
	font       *truetype.Font
	mu         sync.RWMutex
	cache      map[string]*captchaItem
	expiration time.Duration
}

type captchaItem struct {
	value     string
	createdAt time.Time
}

// NewCaptchaService 创建验证码服务
func NewCaptchaService(rdb *redis.Client) (*CaptchaService, error) {
	// 加载字体（使用系统字体或嵌入字体）
	font, err := loadFont()
	if err != nil {
		return nil, fmt.Errorf("加载字体失败：%v", err)
	}

	return &CaptchaService{
		rdb:        rdb,
		font:       font,
		cache:      make(map[string]*captchaItem),
		expiration: time.Minute * 5, // 5 分钟过期
	}, nil
}

// Generate 生成图形验证码
func (s *CaptchaService) Generate(ctx context.Context, captchaID string) (string, error) {
	// 生成随机验证码（6 位，排除易混淆字符）
	chars := "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"
	value := generateRandomString(chars, 6)

	// 生成验证码图片
	img, err := s.generateImage(value)
	if err != nil {
		return "", err
	}

	// 编码为 JPEG
	var buf strings.Builder
	encoder := base64.NewEncoder(base64.StdEncoding, &buf)
	err = jpeg.Encode(encoder, img, &jpeg.Options{Quality: 80})
	encoder.Close()
	if err != nil {
		return "", err
	}

	// 存储到 Redis（5 分钟过期）
	key := fmt.Sprintf("captcha:%s", captchaID)
	err = s.rdb.Set(ctx, key, strings.ToLower(value), s.expiration).Err()
	if err != nil {
		return "", err
	}

	return buf.String(), nil
}

// Verify 验证验证码
func (s *CaptchaService) Verify(ctx context.Context, captchaID, code string) error {
	key := fmt.Sprintf("captcha:%s", captchaID)
	
	storedCode, err := s.rdb.Get(ctx, key).Result()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return ErrCaptchaNotFound
		}
		return err
	}

	// 验证后立即删除（防止重放攻击）
	s.rdb.Del(ctx, key)

	if strings.ToLower(code) != storedCode {
		return ErrCaptchaMismatch
	}

	return nil
}

// generateImage 生成验证码图片
func (s *CaptchaService) generateImage(value string) (image.Image, error) {
	width := 120
	height := 40

	// 创建图片
	img := image.NewRGBA(image.Rect(0, 0, width, height))

	// 随机背景色（浅绿色系）
	bgColors := []color.RGBA{
		{240, 253, 244, 255}, // #F0FDF4
		{220, 252, 231, 255}, // #DCFCE7
		{187, 247, 208, 255}, // #BBF7D0
		{236, 253, 245, 255}, // #ECFDF5
	}
	bgColor := bgColors[randomInt(len(bgColors))]
	draw.Draw(img, img.Bounds(), &image.Uniform{bgColor}, image.Point{}, draw.Src)

	// 添加干扰线
	for i := 0; i < 5; i++ {
		x1 := randomInt(width)
		y1 := randomInt(height)
		x2 := randomInt(width)
		y2 := randomInt(height)
		
		lineColor := color.RGBA{
			R: uint8(16 + randomInt(50)),
			G: uint8(185 + randomInt(50)),
			B: uint8(129),
			A: uint8(30 + randomInt(50)),
		}
		
		drawLine(img, x1, y1, x2, y2, lineColor)
	}

	// 添加干扰点
	for i := 0; i < 30; i++ {
		x := randomInt(width)
		y := randomInt(height)
		pointColor := color.RGBA{
			R: uint8(16 + randomInt(50)),
			G: uint8(185 + randomInt(50)),
			B: uint8(129),
			A: uint8(50 + randomInt(100)),
		}
		img.Set(x, y, pointColor)
	}

	// 绘制验证码文字
	charWidth := width / len(value)
	fontSize := 24.0

	for i, char := range value {
		x := i*charWidth + 10
		y := height/2 + int(fontSize)/2

		// 随机旋转角度
		angle := (float64(randomInt(40)) - 20) / 180 * math.Pi

		// 随机颜色（深绿色系）
		textColors := []color.RGBA{
			{5, 150, 105, 255},  // #059669
			{4, 120, 87, 255},   // #047857
			{6, 95, 70, 255},    // #065F46
			{16, 185, 129, 255}, // #10B981
		}
		textColor := textColors[randomInt(len(textColors))]

		// 绘制字符
		s.drawChar(img, string(char), x, y, fontSize, angle, textColor)
	}

	return img, nil
}

// drawChar 绘制单个字符
func (s *CaptchaService) drawChar(img *image.RGBA, char string, x, y int, fontSize, angle float64, clr color.RGBA) {
	// 创建绘图上下文
	c := freetype.NewContext()
	c.SetDPI(96)
	c.SetFont(s.font)
	c.SetFontSize(fontSize)
	c.SetClip(img.Bounds())
	c.SetDst(img)
	c.SetSrc(image.NewUniform(clr))

	// 应用旋转
	pt := freetype.Pt(x, y)
	
	// 绘制字符
	_, err := c.DrawString(char, pt)
	if err != nil {
		return
	}
}

// generateRandomString 生成随机字符串
func generateRandomString(chars string, length int) string {
	result := make([]byte, length)
	for i := 0; i < length; i++ {
		idx, _ := rand.Int(rand.Reader, big.NewInt(int64(len(chars))))
		result[i] = chars[idx.Int64()]
	}
	return string(result)
}

// randomInt 生成随机整数
func randomInt(max int) int {
	n, _ := rand.Int(rand.Reader, big.NewInt(int64(max)))
	return int(n.Int64())
}

// drawLine 绘制直线
func drawLine(img *image.RGBA, x1, y1, x2, y2 int, c color.RGBA) {
	dx := int(math.Abs(float64(x2 - x1)))
	dy := int(math.Abs(float64(y2 - y1)))
	
	var sx, sy int
	if x1 < x2 {
		sx = 1
	} else {
		sx = -1
	}
	if y1 < y2 {
		sy = 1
	} else {
		sy = -1
	}
	
	err := dx - dy
	for {
		img.Set(x1, y1, c)
		if x1 == x2 && y1 == y2 {
			break
		}
		e2 := 2 * err
		if e2 > -dy {
			err -= dy
			x1 += sx
		}
		if e2 < dx {
			err += dx
			y1 += sy
		}
	}
}

// loadFont 加载字体
func loadFont() (*truetype.Font, error) {
	// 尝试从系统加载字体
	fontPaths := []string{
		"/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
		"/usr/share/fonts/TTF/DejaVuSans-Bold.ttf",
		"/System/Library/Fonts/Helvetica.ttc",
		"C:\\Windows\\Fonts\\arial.ttf",
	}
	
	for _, path := range fontPaths {
		fontData, err := freetype.ReadFontFile(path)
		if err == nil {
			return fontData, nil
		}
	}
	
	// 如果系统字体不可用，使用内置字体（需要嵌入）
	return nil, errors.New("未找到可用字体")
}

// SendSMSCode 发送短信验证码
func (s *CaptchaService) SendSMSCode(ctx context.Context, phone string) (string, error) {
	// 生成 6 位数字验证码
	code := generateRandomString("0123456789", 6)
	
	// 存储到 Redis（5 分钟过期）
	key := fmt.Sprintf("sms:%s", phone)
	err := s.rdb.Set(ctx, key, code, time.Minute*5).Err()
	if err != nil {
		return "", err
	}
	
	// TODO: 调用短信服务商 API 发送验证码
	// 这里只返回验证码用于测试
	fmt.Printf("【Green Recycle】您的验证码是：%s，5 分钟内有效。如非本人操作，请忽略本短信。\n", code)
	
	return code, nil
}

// VerifySMSCode 验证短信验证码
func (s *CaptchaService) VerifySMSCode(ctx context.Context, phone, code string) error {
	key := fmt.Sprintf("sms:%s", phone)
	
	storedCode, err := s.rdb.Get(ctx, key).Result()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return ErrCaptchaNotFound
		}
		return err
	}
	
	// 验证后立即删除
	s.rdb.Del(ctx, key)
	
	if code != storedCode {
		return ErrCaptchaMismatch
	}
	
	return nil
}

// GetSMSCodeCooldown 获取短信验证码冷却时间
func (s *CaptchaService) GetSMSCodeCooldown(ctx context.Context, phone string) (int64, error) {
	key := fmt.Sprintf("sms:cooldown:%s", phone)
	
	ttl, err := s.rdb.TTL(ctx, key).Result()
	if err != nil {
		return 0, err
	}
	
	return int64(ttl.Seconds()), nil
}

// SetSMSCodeCooldown 设置短信验证码冷却时间
func (s *CaptchaService) SetSMSCodeCooldown(ctx context.Context, phone string, seconds int64) error {
	key := fmt.Sprintf("sms:cooldown:%s", phone)
	return s.rdb.Set(ctx, key, "1", time.Duration(seconds)*time.Second).Err()
}
