# ♻️ Green Recycle - 智能废品回收平台

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](README.md)
[![PHP](https://img.shields.io/badge/PHP-8.2+-purple.svg)](https://php.net)
[![Go](https://img.shields.io/badge/Go-1.21+-cyan.svg)](https://go.dev)

> 🌍 让回收更简单，让环境更美好

---

## 📖 项目简介

**Green Recycle** 是一个全平台的智能废品回收管理系统，解决传统回收行业的痛点：

### 用户痛点
- ❌ 不知道废品回收价格
- ❌ 找不到附近的回收点
- ❌ 回收人员上门时间不确定
- ❌ 废品分类不清楚
- ❌ 回收过程不透明

### 解决方案
- ✅ 实时价格查询
- ✅ GPS 定位附近回收点
- ✅ 在线预约，准时上门
- ✅ AI 智能分类识别
- ✅ 全流程透明可追溯

---

## 🎯 核心功能

### 用户端
| 功能 | 说明 |
|------|------|
| 📱 扫码下单 | 扫描废品二维码，快速下单 |
| 🗺️ 附近回收点 | GPS 定位，显示附近回收站点 |
| 💰 实时价格 | 各类废品实时回收价格 |
| 📅 预约上门 | 选择时间，回收员准时上门 |
| 📊 回收记录 | 历史回收记录，收益统计 |
| 🏆 积分系统 | 回收得积分，兑换礼品 |
| 🔔 消息通知 | 订单状态实时推送 |

### 回收员端
| 功能 | 说明 |
|------|------|
| 📋 订单管理 | 接单/拒单/完成订单 |
| 🗺️ 路线规划 | 智能规划最优回收路线 |
| 💵 收益统计 | 每日/周/月收益报表 |
| ⭐ 评价系统 | 用户评价，提升服务质量 |
| 📍 位置打卡 | 上门打卡，确保服务到位 |

### 管理后台
| 功能 | 说明 |
|------|------|
| 📊 数据看板 | 实时订单、收益、用户数据 |
| 👥 用户管理 | 用户/回收员信息管理 |
| 📦 订单管理 | 全平台订单统一管理 |
| 💰 价格管理 | 废品价格实时调整 |
| 📈 报表分析 | 多维度数据分析报表 |

---

## 🏗️ 技术架构

```
┌─────────────────────────────────────────────────────────────┐
│                      前端展示层                              │
├─────────────┬─────────────┬─────────────┬───────────────────┤
│   PC Web    │  移动端 H5   │   小程序     │      APP          │
│  (Vue3)     │  (Vue3)     │ (Uni-app)   │   (Flutter)       │
└─────────────┴─────────────┴─────────────┴───────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      API 网关层                               │
│                        (Go)                                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      后端服务层                              │
├─────────────┬─────────────┬─────────────┬───────────────────┤
│  用户服务    │  订单服务    │  支付服务    │    消息服务        │
│   (Go)      │   (Go)      │   (Go)      │     (Go)          │
└─────────────┴─────────────┴─────────────┴───────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      数据存储层                              │
├─────────────┬─────────────┬─────────────┬───────────────────┤
│   MySQL     │   Redis     │  MongoDB    │   MinIO           │
│  (主数据库)  │  (缓存)     │  (日志)     │  (文件存储)        │
└─────────────┴─────────────┴─────────────┴───────────────────┘
```

---

## 📁 项目结构

```
green-recycle/
├── docs/                      # 文档目录
│   ├── operation-guide.md     # 操作文档
│   ├── deployment-guide.md    # 部署文档
│   ├── api-reference.md       # API 文档
│   └── faq.md                 # 常见问题
├── backend/                   # 后端服务 (Go)
│   ├── cmd/                   # 可执行文件
│   ├── internal/              # 内部包
│   │   ├── handler/           # HTTP 处理器
│   │   ├── service/           # 业务逻辑
│   │   ├── model/             # 数据模型
│   │   └── repository/        # 数据访问
│   ├── pkg/                   # 公共包
│   ├── configs/               # 配置文件
│   └── scripts/               # 脚本
├── frontend/                  # 前端项目
│   ├── pc-web/               # PC 端 (Vue3)
│   ├── mobile-web/           # 移动端 H5 (Vue3)
│   ├── mini-program/         # 小程序 (Uni-app)
│   └── app/                  # APP (Flutter)
├── admin/                     # 管理后台 (Vue3 + Element Plus)
├── docker/                    # Docker 配置
├── scripts/                   # 部署脚本
└── tests/                     # 测试文件
```

---

## 🚀 快速开始

### 环境要求

| 软件 | 版本 | 说明 |
|------|------|------|
| Go | 1.21+ | 后端服务 |
| PHP | 8.2+ | 可选，部分服务 |
| Node.js | 18+ | 前端构建 |
| MySQL | 8.0+ | 主数据库 |
| Redis | 7.0+ | 缓存服务 |
| Docker | 24+ | 容器化部署 |

### 本地开发

```bash
# 1. 克隆项目
git clone https://github.com/xiaohei7529/green-recycle.git
cd green-recycle

# 2. 启动后端服务
cd backend
go run cmd/main.go

# 3. 启动前端
cd frontend/pc-web
npm install
npm run dev

# 4. 启动管理后台
cd admin
npm install
npm run dev
```

### Docker 部署

```bash
# 一键部署
docker-compose up -d

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

---

## 📖 详细文档

| 文档 | 说明 | 链接 |
|------|------|------|
| 📘 操作文档 | 用户/回收员/管理员操作指南 | [docs/operation-guide.md](docs/operation-guide.md) |
| 📗 部署文档 | 生产环境部署步骤 | [docs/deployment-guide.md](docs/deployment-guide.md) |
| 📙 API 文档 | 完整 API 接口说明 | [docs/api-reference.md](docs/api-reference.md) |
| ❓ 常见问题 | 常见问题解答 | [docs/faq.md](docs/faq.md) |

---

## 🎨 界面预览

### 用户端
- 📱 首页：附近回收点、快速下单
- 📦 订单：订单列表、订单详情
- 💰 价格：废品价格列表
- 👤 我的：个人信息、回收记录

### 回收员端
- 📋 订单：待接单、进行中、已完成
- 🗺️ 路线：智能路线规划
- 💵 收益：收益统计
- ⭐ 评价：用户评价

### 管理后台
- 📊 数据看板：实时数据
- 👥 用户管理：用户列表
- 📦 订单管理：订单列表
- 💰 价格管理：价格配置

---

## 🤝 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📄 开源协议

本项目采用 [MIT](LICENSE) 协议开源

---

## 📞 联系方式

- 📧 Email: xiaohei7529@gmail.com
- 💬 Issues: [GitHub Issues](https://github.com/xiaohei7529/green-recycle/issues)
- 📖 Wiki: [项目 Wiki](https://github.com/xiaohei7529/green-recycle/wiki)

---

## 🙏 致谢

感谢所有为本项目做出贡献的开发者！

---

**Made with ❤️ by Green Recycle Team**
