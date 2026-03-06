# 🚀 Green Recycle - 启动指南

---

## ⚠️ 重要提示

**Docker Compose 命令**:
- 新版 Docker: `docker compose up -d` (无连字符)
- 旧版 Docker: `docker-compose up -d` (有连字符)

---

## 方式一：Docker 一键启动（推荐）

### 1. 检查环境

```bash
# 检查 Docker
docker --version

# 检查 Docker Compose
docker compose version
# 或
docker-compose version
```

### 2. 启动服务

**新版 Docker (20.10+)**:
```bash
cd green-recycle
docker compose up -d
```

**旧版 Docker**:
```bash
cd green-recycle
docker-compose up -d
```

### 3. 查看状态

```bash
# 查看容器状态
docker compose ps
# 或
docker-compose ps

# 查看日志
docker compose logs -f
# 或
docker-compose logs -f
```

### 4. 访问服务

| 服务 | 地址 | 说明 |
|------|------|------|
| 前端 | http://localhost | PC 端 |
| 后端 API | http://localhost:8080 | API 接口 |
| 健康检查 | http://localhost:8080/health | 健康状态 |

### 5. 停止服务

```bash
docker compose down
# 或
docker-compose down
```

---

## 方式二：本地开发启动

### 1. 启动数据库

```bash
# Docker 启动 MySQL
docker run -d --name mysql \
  -e MYSQL_ROOT_PASSWORD=green_recycle_2026 \
  -e MYSQL_DATABASE=green_recycle \
  -p 3306:3306 \
  mysql:8.0

# Docker 启动 Redis
docker run -d --name redis \
  -p 6379:6379 \
  redis:7-alpine
```

### 2. 初始化数据库

```bash
mysql -u root -pgreen_recycle_2026 green_recycle < backend/scripts/schema.sql
mysql -u root -pgreen_recycle_2026 green_recycle < backend/scripts/init_data.sql
```

### 3. 启动后端

```bash
cd backend

# 下载依赖
go mod download

# 设置环境变量
export DB_DSN="green_recycle:green_recycle_2026@tcp(127.0.0.1:3306)/green_recycle?charset=utf8mb4&parseTime=True&loc=Local"
export REDIS_ADDR="127.0.0.1:6379"
export JWT_SECRET="green_recycle_jwt_secret_key_2026"
export PORT=8080

# 启动服务
go run cmd/main.go
```

### 4. 启动前端

```bash
# PC 端
cd frontend/pc-web
npm install
npm run dev
# 访问 http://localhost:5173

# 移动端 H5
cd frontend/mobile-web
npm install
npm run dev
# 访问 http://localhost:5174

# 管理后台
cd admin
npm install
npm run dev
# 访问 http://localhost:5175
```

---

## 常见问题排查

### Q1: Docker Compose 命令不存在

**解决方案**:
```bash
# 安装 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 或者使用新版命令
docker compose
```

### Q2: 后端启动失败 - 数据库连接错误

**检查 MySQL 是否启动**:
```bash
docker compose ps mysql
# 或
docker ps | grep mysql
```

**查看 MySQL 日志**:
```bash
docker compose logs mysql
# 或
docker logs green-recycle-mysql
```

**手动测试连接**:
```bash
mysql -h 127.0.0.1 -P 3306 -u green_recycle -pgreen_recycle_2026 green_recycle
```

### Q3: 后端启动失败 - Redis 连接错误

**检查 Redis 是否启动**:
```bash
docker compose ps redis
```

**测试 Redis 连接**:
```bash
redis-cli -h 127.0.0.1 -p 6379 ping
# 应该返回 PONG
```

### Q4: 前端页面空白

**检查后端 API**:
```bash
curl http://localhost:8080/health
# 应该返回 {"status":"ok"}
```

**检查前端构建**:
```bash
cd frontend/pc-web
npm run build
```

**查看浏览器控制台**:
- 打开开发者工具 (F12)
- 查看 Console 和 Network 标签

### Q5: 端口被占用

**检查端口占用**:
```bash
# 检查 8080 端口
lsof -i :8080

# 检查 80 端口
lsof -i :80

# 检查 3306 端口
lsof -i :3306
```

**解决方案**:
```bash
# 停止占用端口的服务
kill -9 <PID>

# 或者修改 docker-compose.yml 中的端口映射
ports:
  - "8081:8080"  # 改为 8081
```

### Q6: Go 依赖下载失败

**使用国内镜像**:
```bash
cd backend
export GOPROXY=https://goproxy.cn,direct
go mod download
```

### Q7: npm 依赖安装失败

**使用淘宝镜像**:
```bash
npm config set registry https://registry.npmmirror.com
npm install
```

---

## 环境变量说明

### 后端环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| DB_DSN | - | MySQL 连接字符串 |
| REDIS_ADDR | 127.0.0.1:6379 | Redis 地址 |
| JWT_SECRET | - | JWT 密钥 |
| PORT | 8080 | 服务端口 |
| GIN_MODE | debug | Gin 模式 (debug/release) |

### Docker 环境变量

已在 `docker-compose.yml` 中配置，无需手动设置。

---

## 验证部署

### 1. 健康检查

```bash
curl http://localhost:8080/health
# 返回：{"status":"ok"}
```

### 2. 测试 API

```bash
# 获取价格列表
curl http://localhost:8080/api/v1/prices

# 用户注册
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138000","code":"123456","password":"password123"}'
```

### 3. 访问前端

打开浏览器访问：
- PC 端：http://localhost
- 移动端：http://localhost/m
- 管理后台：http://localhost/admin

---

## 日志查看

```bash
# 查看所有服务日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f mysql
docker compose logs -f redis
```

---

## 重启服务

```bash
# 重启所有服务
docker compose restart

# 重启单个服务
docker compose restart backend
docker compose restart frontend

# 强制重新构建
docker compose up -d --build
```

---

## 数据备份

```bash
# 备份 MySQL 数据
docker exec green-recycle-mysql mysqldump -u root -pgreen_recycle_2026 green_recycle > backup.sql

# 恢复 MySQL 数据
docker exec -i green-recycle-mysql mysql -u root -pgreen_recycle_2026 green_recycle < backup.sql
```

---

## 清理数据

```bash
# 停止并删除容器（保留数据卷）
docker compose down

# 停止并删除容器和数据卷（谨慎！）
docker compose down -v
```

---

**最后更新**: 2026-03-06  
**版本**: v1.0.0
