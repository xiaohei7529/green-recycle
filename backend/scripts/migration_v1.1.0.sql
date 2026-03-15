-- Green Recycle v1.1.0 数据库优化迁移
-- 执行时间：2026-03-15
-- 目标：添加索引优化查询性能

-- 1. 用户表索引
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_users_status ON users(status);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- 2. 订单表索引
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_recycler_id ON orders(recycler_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_order_no ON orders(order_no);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_orders_district ON orders(district);

-- 3. 订单项表索引
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_category ON order_items(category);

-- 4. 价格表索引
CREATE INDEX IF NOT EXISTS idx_prices_category ON prices(category);
CREATE INDEX IF NOT EXISTS idx_prices_updated_at ON prices(updated_at);

-- 5. 积分记录表索引
CREATE INDEX IF NOT EXISTS idx_points_logs_user_id ON points_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_points_logs_created_at ON points_logs(created_at);

-- 6. 回收员表索引
CREATE INDEX IF NOT EXISTS idx_recyclers_status ON recyclers(status);
CREATE INDEX IF NOT EXISTS idx_recyclers_district ON recyclers(district);

-- 7. 复合索引（常用查询场景）
-- 用户订单查询
CREATE INDEX IF NOT EXISTS idx_orders_user_status ON orders(user_id, status);
CREATE INDEX IF NOT EXISTS idx_orders_user_created ON orders(user_id, created_at DESC);

-- 回收员订单查询
CREATE INDEX IF NOT EXISTS idx_orders_recycler_status ON orders(recycler_id, status);

-- 价格查询（分类 + 时间）
CREATE INDEX IF NOT EXISTS idx_prices_category_updated ON prices(category, updated_at DESC);

-- 8. 性能优化配置
-- 设置 InnoDB 缓冲池大小（根据服务器内存调整）
-- SET GLOBAL innodb_buffer_pool_size = 1073741824; -- 1GB

-- 9. 分析表统计信息
ANALYZE TABLE users;
ANALYZE TABLE orders;
ANALYZE TABLE order_items;
ANALYZE TABLE prices;
ANALYZE TABLE recyclers;

-- 迁移完成
-- 验证：使用 EXPLAIN 检查查询计划
-- 示例：EXPLAIN SELECT * FROM orders WHERE user_id = 1 AND status = 0;
