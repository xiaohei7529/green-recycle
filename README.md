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

### 管理端
| 功能 | 说明 |
|------|------|
| 📊 数据看板 | 回收数据实时统计 |
| 👥 用户管理 | 用户和回收员管理 |
| 📦 废品管理 | 废品分类和价格管理 |
| 📈 报表分析 | 业务数据分析 |

---

## 📊 开发状态

**当前版本**: v1.0.0  
**开发状态**: 🟢 正常开发  
**最后更新**: 2026-03-15

### 本周进展 (2026-03-09 至 2026-03-15)

**核心成就**:
- ✅ 自主开发工作流建立
- ✅ 每日报告机制完善
- ✅ v1.1.0 规划完成
- ✅ 文档体系完善

**Git 统计**:
- 本周提交：18 次
- 代码行数：1000+ 行
- 文档数量：12 份

**已完成功能**:
- ✅ 项目基础架构
- ✅ 后端 API
- ✅ 前端 UI
- ✅ 每日报告机制

**下周计划 (v1.1.0)**:
- [ ] 后端 API 优化
- [ ] 前端 UI 改进
- [ ] 用户认证优化
- [ ] 数据可视化

---

## 📁 项目结构

```
green-recycle/
├── frontend/         # 前端应用
│   └── app/          # Vue 应用
├── backend/          # 后端 API
│   └── api/          # Go API
├── docs/             # 文档
├── reports/          # 报告
└── scripts/          # 脚本
```

---

## 🛠️ 技术栈

### 前端
- **框架**: Vue 3.4
- **UI 库**: Element Plus 2.5
- **构建**: Vite 5.0

### 后端
- **语言**: Go 1.21+ / PHP 8.2+
- **框架**: Gin / Laravel
- **数据库**: MySQL/SQLite

### 部署
- **Docker**: 容器化部署
- **Nginx**: Web 服务器

---

## 📖 文档导航

| 文档 | 说明 |
|------|------|
| [快速开始](docs/QUICKSTART.md) | 5 分钟快速上手 |
| [启动指南](START.md) | 详细启动步骤 |
| [自主开发流程](docs/AUTONOMOUS_DEV_WORKFLOW.md) | 自主开发工作流 |
| [API 文档](docs/api-reference.md) | API 接口参考 |
| [运营指南](docs/operation-guide.md) | 运营操作指南 |
| [v1.1.0 规划](docs/v1.1.0-plan.md) | 下版本开发计划 |

---

## 🚀 快速开始

### Docker 部署 (推荐)

```bash
# 1. 克隆项目
git clone https://github.com/xiaohei7529/green-recycle.git
cd green-recycle

# 2. 启动服务
docker-compose up -d

# 3. 访问应用
# http://localhost:8080
```

### 本地开发

```bash
# 1. 安装依赖
composer install
npm install

# 2. 配置环境变量
cp .env.example .env

# 3. 启动服务
php artisan serve
npm run dev

# 4. 访问应用
# http://localhost:8000
```

---

## 🤝 贡献指南

欢迎贡献代码、文档或建议！

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交变更 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

---

## 📄 开源协议

本项目采用 MIT 协议开源 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 🙏 致谢

感谢以下开源项目：
- [Vue.js](https://vuejs.org/)
- [Element Plus](https://element-plus.org/)
- [Laravel](https://laravel.com/)
- [Gin](https://gin-gonic.com/)

---

## 📞 联系方式

- **GitHub**: https://github.com/xiaohei7529/green-recycle
- **Issues**: https://github.com/xiaohei7529/green-recycle/issues
- **Email**: xiaohei7529@gmail.com

---

*Green Recycle v1.0.0 - 让回收更简单，让环境更美好！* ♻️

**最后更新**: 2026-03-15
