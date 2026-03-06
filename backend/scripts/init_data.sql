-- Green Recycle 初始化数据
-- 版本：v1.0.0
-- 创建时间：2026-03-06

USE `green_recycle`;

-- 插入测试用户
INSERT INTO `users` (`phone`, `password`, `nickname`, `avatar`, `points`, `status`) VALUES
('13800138000', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '测试用户', 'https://example.com/avatar1.jpg', 1250, 1),
('13900139000', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '张三', 'https://example.com/avatar2.jpg', 580, 1),
('13700137000', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '李四', 'https://example.com/avatar3.jpg', 320, 1);

-- 插入回收员
INSERT INTO `recyclers` (`user_id`, `name`, `id_card`, `service_areas`, `rating`, `total_orders`, `total_income`, `status`) VALUES
(2, '张三', '320682199001011234', '["如皋市"]', 4.8, 158, 3580.50, 1),
(3, '李四', '320682199202022345', '["如皋市"]', 4.9, 203, 4250.00, 1);

-- 插入废品分类
INSERT INTO `categories` (`name`, `parent_id`, `icon`, `sort`, `status`) VALUES
('纸类', 0, '📰', 1, 1),
('报纸', 1, NULL, 1, 1),
('纸箱', 1, NULL, 2, 1),
('书本', 1, NULL, 3, 1),
('塑料', 0, '🥤', 2, 1),
('PET 瓶', 5, NULL, 1, 1),
('PE 膜', 5, NULL, 2, 1),
('PP 塑料', 5, NULL, 3, 1),
('金属', 0, '🥫', 3, 1),
('铁', 9, NULL, 1, 1),
('铝', 9, NULL, 2, 1),
('铜', 9, NULL, 3, 1),
('电器', 0, '🔌', 4, 1),
('空调', 13, NULL, 1, 1),
('冰箱', 13, NULL, 2, 1),
('洗衣机', 13, NULL, 3, 1);

-- 插入价格数据
INSERT INTO `prices` (`category_id`, `name`, `price`, `unit`, `city`, `effective_date`) VALUES
(2, '报纸', 1.50, 'kg', '全国', '2026-03-06'),
(3, '纸箱', 1.20, 'kg', '全国', '2026-03-06'),
(4, '书本', 1.80, 'kg', '全国', '2026-03-06'),
(6, 'PET 瓶', 2.00, 'kg', '全国', '2026-03-06'),
(7, 'PE 膜', 3.50, 'kg', '全国', '2026-03-06'),
(8, 'PP 塑料', 4.00, 'kg', '全国', '2026-03-06'),
(10, '铁', 3.50, 'kg', '全国', '2026-03-06'),
(11, '铝', 12.00, 'kg', '全国', '2026-03-06'),
(12, '铜', 45.00, 'kg', '全国', '2026-03-06'),
(14, '空调', 150.00, '台', '全国', '2026-03-06'),
(15, '冰箱', 100.00, '台', '全国', '2026-03-06'),
(16, '洗衣机', 80.00, '台', '全国', '2026-03-06');

-- 插入测试订单
INSERT INTO `orders` (`order_no`, `user_id`, `recycler_id`, `type`, `status`, `province`, `city`, `district`, `address`, `contact_name`, `contact_phone`, `pickup_time`, `total_weight`, `total_amount`, `remark`, `completed_at`) VALUES
('ORD20260305001', 1, 2, 1, 3, '江苏省', '南通市', '如皋市', 'XX 小区 X 栋 X 单元', '测试用户', '13800138000', '2026-03-05 10:00:00', 5.50, 15.50, '请上门回收', '2026-03-05 11:30:00'),
('ORD20260305002', 1, NULL, 1, 0, '江苏省', '南通市', '如皋市', 'XX 花园 X 号楼', '测试用户', '13800138000', '2026-03-06 14:00:00', 10.00, 28.00, '有很多纸箱', NULL),
('ORD20260304001', 1, 3, 1, 3, '江苏省', '南通市', '如皋市', 'XX 路 XX 号', '测试用户', '13800138000', '2026-03-04 09:00:00', 8.20, 35.60, '旧书回收', '2026-03-04 10:30:00');

-- 插入订单物品明细
INSERT INTO `order_items` (`order_id`, `category_id`, `category`, `weight`, `price`, `amount`) VALUES
(1, 2, '报纸', 3.00, 1.50, 4.50),
(1, 3, '纸箱', 2.50, 1.20, 3.00),
(1, 4, '书本', 0.00, 0.00, 0.00),
(1, 10, '铁', 0.00, 0.00, 0.00),
(2, 3, '纸箱', 10.00, 1.20, 12.00),
(2, 6, 'PET 瓶', 8.00, 2.00, 16.00),
(3, 4, '书本', 8.20, 1.80, 14.76),
(3, 2, '报纸', 5.00, 1.50, 7.50),
(3, 10, '铁', 3.50, 3.50, 12.25);

-- 插入回收点
INSERT INTO `stations` (`name`, `province`, `city`, `district`, `address`, `latitude`, `longitude`, `hours`, `phone`, `rating`, `status`) VALUES
('如皋回收站 A', '江苏省', '南通市', '如皋市', '如皋市 XX 路 XX 号', 32.39000000, 120.57000000, '08:00-20:00', '13800138001', 4.8, 1),
('如皋回收站 B', '江苏省', '南通市', '如皋市', '如皋市 YY 路 YY 号', 32.38500000, 120.56500000, '08:00-20:00', '13800138002', 4.6, 1),
('如皋回收站 C', '江苏省', '南通市', '如皋市', '如皋市 ZZ 路 ZZ 号', 32.39500000, 120.57500000, '08:00-18:00', '13800138003', 4.9, 1);

-- 插入积分记录
INSERT INTO `points_logs` (`user_id`, `type`, `points`, `balance`, `reason`, `related_id`) VALUES
(1, 1, 100, 1250, '完成回收订单', 1),
(1, 1, 50, 1150, '完成回收订单', 3),
(1, 1, 5, 1100, '每日签到', NULL),
(1, 2, 100, 1095, '积分商城兑换', NULL);

-- 插入系统配置
INSERT INTO `settings` (`key`, `value`, `description`) VALUES
('site_name', 'Green Recycle', '网站名称'),
('site_logo', '♻️', '网站 Logo'),
('customer_service_phone', '400-XXX-XXXX', '客服电话'),
('customer_service_hours', '08:00-22:00', '客服时间'),
('min_order_weight', '1.0', '最小下单重量（kg）'),
('points_rate', '1', '积分比例（1 元=1 积分）'),
('recruiter_commission_rate', '0.8', '回收员分成比例');
