package main

import (
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/xiaohei7529/green-recycle/backend/internal/handler"
	"github.com/xiaohei7529/green-recycle/backend/internal/repository"
	"github.com/xiaohei7529/green-recycle/backend/internal/service"
)

func main() {
	// 初始化数据库连接
	dsn := os.Getenv("DB_DSN")
	if dsn == "" {
		dsn = "root:password@tcp(127.0.0.1:3306)/green_recycle?charset=utf8mb4&parseTime=True&loc=Local"
	}
	
	db, err := repository.NewMySQLRepository(dsn)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// 初始化 Redis 连接
	redisAddr := os.Getenv("REDIS_ADDR")
	if redisAddr == "" {
		redisAddr = "127.0.0.1:6379"
	}
	
	rdb, err := repository.NewRedisRepository(redisAddr)
	if err != nil {
		log.Fatalf("Failed to connect to redis: %v", err)
	}

	// 初始化服务
	userService := service.NewUserService(db, rdb)
	authService := service.NewAuthService(db, rdb)
	orderService := service.NewOrderService(db, rdb)
	priceService := service.NewPriceService(db)

	// 初始化处理器
	authHandler := handler.NewAuthHandler(authService)
	userHandler := handler.NewUserHandler(userService)
	orderHandler := handler.NewOrderHandler(orderService)
	priceHandler := handler.NewPriceHandler(priceService)

	// 初始化 Gin 路由
	r := gin.Default()

	// 健康检查
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	// API v1 路由
	v1 := r.Group("/api/v1")
	{
		// 认证接口
		auth := v1.Group("/auth")
		{
			auth.POST("/register", authHandler.Register)
			auth.POST("/login", authHandler.Login)
			auth.POST("/wechat", authHandler.WechatLogin)
		}

		// 用户接口（需要认证）
		user := v1.Group("/user")
		user.Use(handler.AuthMiddleware())
		{
			user.GET("/profile", userHandler.GetProfile)
			user.PUT("/profile", userHandler.UpdateProfile)
		}

		// 订单接口（需要认证）
		orders := v1.Group("/orders")
		orders.Use(handler.AuthMiddleware())
		{
			orders.POST("", orderHandler.CreateOrder)
			orders.GET("", orderHandler.ListOrders)
			orders.GET("/:id", orderHandler.GetOrder)
			orders.POST("/:id/cancel", orderHandler.CancelOrder)
		}

		// 价格接口（公开）
		prices := v1.Group("/prices")
		{
			prices.GET("", priceHandler.ListPrices)
		}
	}

	// 启动服务
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server starting on port %s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
