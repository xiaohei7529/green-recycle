package repository

import (
	"github.com/go-redis/redis/v8"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

// NewMySQLRepository 创建 MySQL 连接
func NewMySQLRepository(dsn string) (*gorm.DB, error) {
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, err
	}

	// 获取底层 SQL DB 连接池
	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	// 设置连接池参数
	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)

	return db, nil
}

// NewRedisRepository 创建 Redis 连接
func NewRedisRepository(addr string) (*redis.Client, error) {
	rdb := redis.NewClient(&redis.Options{
		Addr: addr,
	})

	// 测试连接
	if err := rdb.Ping(rdb.Context()).Err(); err != nil {
		return nil, err
	}

	return rdb, nil
}
