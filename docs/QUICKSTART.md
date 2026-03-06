# 🚀 Green Recycle - 快速开始指南

---

## 方式一：Docker 一键部署（推荐）

### 1. 克隆项目

```bash
git clone https://github.com/xiaohei7529/green-recycle.git
cd green-recycle
```

### 2. 启动服务

```bash
docker-compose up -d
```

### 3. 查看状态

```bash
docker-compose ps
```

### 4. 访问服务

| 服务 | 地址 |
|------|------|
| 前端 | http://localhost |
| 后端 API | http://localhost:8080 |
| 管理后台 | http://localhost/admin |

### 5. 查看日志

```bash
docker-compose logs -f
```

### 6. 停止服务

```bash
docker-compose down
```

---

## 方式二：本地开发

### 环境要求

- Go 1.21+
- Node.js 18+
- MySQL 8.0+
- Redis 7.0+

### 1. 启动数据库

```bash
# MySQL
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=root mysql:8.0

# Redis
docker run -d --name redis redis:7-alpine
```

### 2. 启动后端

```bash
cd backend
go mod download
go run cmd/main.go
```

### 3. 启动前端

```bash
cd frontend/pc-web
npm install
npm run dev
```

### 4. 启动管理后台

```bash
cd admin
npm install
npm run dev
```

---

## 方式三：生产环境部署

### 1. 修改配置

编辑 `docker-compose.yml`：
- 修改数据库密码
- 修改 JWT_SECRET
- 配置 SSL 证书

### 2. 使用生产配置启动

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### 3. 配置域名和 SSL

参考 [部署文档](deployment-guide.md)

---

## 常见问题

### Q: 数据库连接失败？

```bash
# 检查 MySQL 是否启动
docker-compose ps mysql

# 查看 MySQL 日志
docker-compose logs mysql
```

### Q: 前端页面空白？

```bash
# 查看前端日志
docker-compose logs frontend

# 检查浏览器控制台
```

### Q: 如何重置数据库？

```bash
docker-compose down -v  # 删除数据卷（谨慎！）
docker-compose up -d
```

---

**更多文档**: [docs/](./)
