-- Green Recycle 数据库初始化脚本
-- 版本：v1.0.0
-- 创建时间：2026-03-06

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `green_recycle` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `green_recycle`;

-- 用户表
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户 ID',
  `phone` varchar(11) NOT NULL COMMENT '手机号',
  `password` varchar(255) NOT NULL COMMENT '密码（加密）',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像 URL',
  `points` int(11) DEFAULT '0' COMMENT '积分',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1 正常 0 禁用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_phone` (`phone`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 回收员表
DROP TABLE IF EXISTS `recyclers`;
CREATE TABLE `recyclers` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '回收员 ID',
  `user_id` int(11) NOT NULL COMMENT '用户 ID',
  `name` varchar(50) NOT NULL COMMENT '姓名',
  `id_card` varchar(18) NOT NULL COMMENT '身份证号',
  `service_areas` json DEFAULT NULL COMMENT '服务区域',
  `rating` decimal(3,2) DEFAULT '5.00' COMMENT '评分',
  `total_orders` int(11) DEFAULT '0' COMMENT '总订单数',
  `total_income` decimal(10,2) DEFAULT '0.00' COMMENT '总收益',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态：0 待审核 1 已启用 2 已禁用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_id_card` (`id_card`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回收员表';

-- 废品分类表
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类 ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `parent_id` int(11) DEFAULT '0' COMMENT '父分类 ID',
  `icon` varchar(255) DEFAULT NULL COMMENT '图标',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1 启用 0 禁用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='废品分类表';

-- 价格表
DROP TABLE IF EXISTS `prices`;
CREATE TABLE `prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '价格 ID',
  `category_id` int(11) NOT NULL COMMENT '分类 ID',
  `name` varchar(50) NOT NULL COMMENT '物品名称',
  `price` decimal(10,2) NOT NULL COMMENT '价格（元/kg）',
  `unit` varchar(10) DEFAULT 'kg' COMMENT '单位',
  `city` varchar(50) DEFAULT '全国' COMMENT '适用城市',
  `effective_date` date DEFAULT NULL COMMENT '生效日期',
  `expiry_date` date DEFAULT NULL COMMENT '失效日期',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_city` (`city`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='价格表';

-- 订单表
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单 ID',
  `order_no` varchar(32) NOT NULL COMMENT '订单号',
  `user_id` int(11) NOT NULL COMMENT '用户 ID',
  `recycler_id` int(11) DEFAULT NULL COMMENT '回收员 ID',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '类型：1 上门回收 2 站点回收',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态：0 待接单 1 已接单 2 回收中 3 已完成 4 已取消',
  `province` varchar(50) DEFAULT NULL COMMENT '省',
  `city` varchar(50) DEFAULT NULL COMMENT '市',
  `district` varchar(50) DEFAULT NULL COMMENT '区',
  `address` varchar(255) NOT NULL COMMENT '详细地址',
  `contact_name` varchar(50) NOT NULL COMMENT '联系人',
  `contact_phone` varchar(11) NOT NULL COMMENT '联系电话',
  `pickup_time` timestamp NULL DEFAULT NULL COMMENT '上门时间',
  `total_weight` decimal(10,2) DEFAULT '0.00' COMMENT '总重量',
  `total_amount` decimal(10,2) DEFAULT '0.00' COMMENT '总金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `completed_at` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `cancelled_at` timestamp NULL DEFAULT NULL COMMENT '取消时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_recycler_id` (`recycler_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 订单物品明细表
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '明细 ID',
  `order_id` int(11) NOT NULL COMMENT '订单 ID',
  `category_id` int(11) DEFAULT NULL COMMENT '分类 ID',
  `category` varchar(50) NOT NULL COMMENT '分类名称',
  `weight` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '重量',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '金额',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单物品明细表';

-- 回收点表
DROP TABLE IF EXISTS `stations`;
CREATE TABLE `stations` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '回收点 ID',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `province` varchar(50) DEFAULT NULL COMMENT '省',
  `city` varchar(50) DEFAULT NULL COMMENT '市',
  `district` varchar(50) DEFAULT NULL COMMENT '区',
  `address` varchar(255) NOT NULL COMMENT '地址',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT '经度',
  `hours` varchar(50) DEFAULT '08:00-20:00' COMMENT '营业时间',
  `phone` varchar(11) DEFAULT NULL COMMENT '电话',
  `rating` decimal(3,2) DEFAULT '5.00' COMMENT '评分',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1 营业 0 休息',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_city` (`city`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回收点表';

-- 积分记录表
DROP TABLE IF EXISTS `points_logs`;
CREATE TABLE `points_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '记录 ID',
  `user_id` int(11) NOT NULL COMMENT '用户 ID',
  `type` tinyint(1) NOT NULL COMMENT '类型：1 获得 2 消费',
  `points` int(11) NOT NULL COMMENT '积分',
  `balance` int(11) NOT NULL COMMENT '变更后余额',
  `reason` varchar(100) NOT NULL COMMENT '原因',
  `related_id` int(11) DEFAULT NULL COMMENT '关联 ID（订单 ID 等）',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分记录表';

-- 系统配置表
DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '配置 ID',
  `key` varchar(50) NOT NULL COMMENT '配置键',
  `value` text COMMENT '配置值',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';
