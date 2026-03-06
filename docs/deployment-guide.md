# 📗 Green Recycle - 部署文档

---

## 目录

1. [环境准备](#1-环境准备)
2. [本地开发环境](#2-本地开发环境)
3. [生产环境部署](#3-生产环境部署)
4. [Docker 部署](#4-docker 部署)
5. [配置说明](#5-配置说明)
6. [常见问题](#6-常见问题)

---

## 1. 环境准备

### 1.1 服务器要求

| 配置 | 开发环境 | 生产环境 |
|------|----------|----------|
| CPU | 2 核 | 4 核+ |
| 内存 | 4GB | 8GB+ |
| 磁盘 | 50GB | 100GB+ |
| 系统 | Ubuntu 22.04 | Ubuntu 22.04 LTS |

### 1.2 软件依赖

| 软件 | 版本 | 用途 |
|------|------|------|
| Go | 1.21+ | 后端服务 |
| Node.js | 18+ | 前端构建 |
| MySQL | 8.0+ | 主数据库 |
| Redis | 7.0+ | 缓存服务 |
| Nginx | 1.24+ | Web 服务器 |
| Docker | 24+ | 容器化 |
| Git | 2.40+ | 版本控制 |

### 1.3 安装基础软件

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Go
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# 安装 Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 安装 MySQL
sudo apt install -y mysql-server

# 安装 Redis
sudo apt install -y redis-server

# 安装 Nginx
sudo apt install -y nginx

# 安装 Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

---

## 2. 本地开发环境

### 2.1 克隆项目

```bash
git clone https://github.com/xiaohei7529/green-recycle.git
cd green-recycle
```

### 2.2 数据库初始化

```bash
# 登录 MySQL
mysql -u root -p

# 创建数据库
CREATE DATABASE green_recycle DEFAULT CHARACTER SET utf8mb4;
CREATE DATABASE green_recycle_test DEFAULT CHARACTER SET utf8mb4;

# 导入表结构
mysql -u root -p green_recycle < backend/scripts/schema.sql
mysql -u root -p green_recycle < backend/scripts/init_data.sql
```

### 2.3 后端服务

```bash
cd backend

# 安装依赖
go mod download

# 复制配置文件
cp configs/config.example.yaml configs/config.yaml

# 修改配置（数据库连接等）
vim configs/config.yaml

# 启动服务
go run cmd/main.go

# 或编译后运行
go build -o main cmd/main.go
./main
```

### 2.4 前端项目

```bash
# PC Web
cd frontend/pc-web
npm install
npm run dev

# 移动端 H5
cd frontend/mobile-web
npm install
npm run dev

# 管理后台
cd admin
npm install
npm run dev

# 小程序
cd frontend/mini-program
npm install
npm run dev:mp-weixin
```

### 2.5 访问地址

| 服务 | 地址 | 端口 |
|------|------|------|
| PC Web | http://localhost:5173 | 5173 |
| 移动端 | http://localhost:5174 | 5174 |
| 管理后台 | http://localhost:5175 | 5175 |
| API | http://localhost:8080 | 8080 |

---

## 3. 生产环境部署

### 3.1 后端部署

```bash
# 编译
cd backend
go build -o main cmd/main.go

# 配置 systemd 服务
sudo vim /etc/systemd/system/green-recycle-backend.service
```

**Systemd 配置**:
```ini
[Unit]
Description=Green Recycle Backend Service
After=network.target mysql.service redis.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/green-recycle/backend
ExecStart=/var/www/green-recycle/backend/main
Restart=always
RestartSec=5
Environment=GIN_MODE=release

[Install]
WantedBy=multi-user.target
```

```bash
# 启动服务
sudo systemctl daemon-reload
sudo systemctl enable green-recycle-backend
sudo systemctl start green-recycle-backend
sudo systemctl status green-recycle-backend
```

### 3.2 前端部署

```bash
# 构建
cd frontend/pc-web
npm run build

cd ../mobile-web
npm run build

cd ../mini-program
npm run build:mp-weixin

cd ../../admin
npm run build
```

### 3.3 Nginx 配置

```bash
sudo vim /etc/nginx/sites-available/green-recycle
```

**Nginx 配置**:
```nginx
server {
    listen 80;
    server_name www.green-recycle.com;
    
    # PC Web
    location / {
        root /var/www/green-recycle/frontend/pc-web/dist;
        try_files $uri $uri/ /index.html;
    }
    
    # 移动端
    location /m {
        root /var/www/green-recycle/frontend/mobile-web/dist;
        try_files $uri $uri/ /index.html;
    }
    
    # 管理后台
    location /admin {
        root /var/www/green-recycle/admin/dist;
        try_files $uri $uri/ /index.html;
    }
    
    # API 代理
    location /api {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

# HTTPS 配置
server {
    listen 443 ssl http2;
    server_name www.green-recycle.com;
    
    ssl_certificate /etc/letsencrypt/live/green-recycle.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/green-recycle.com/privkey.pem;
    
    # 同上配置...
}
```

```bash
# 启用配置
sudo ln -s /etc/nginx/sites-available/green-recycle /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 3.4 SSL 证书

```bash
# 安装 Certbot
sudo apt install -y certbot python3-certbot-nginx

# 申请证书
sudo certbot --nginx -d green-recycle.com -d www.green-recycle.com

# 自动续期
sudo crontab -e
# 添加：0 3 1 * * certbot renew --quiet
```

---

## 4. Docker 部署

### 4.1 构建镜像

```bash
cd green-recycle

# 构建后端镜像
docker build -t green-recycle-backend:latest -f docker/backend/Dockerfile .

# 构建前端镜像
docker build -t green-recycle-frontend:latest -f docker/frontend/Dockerfile .
```

### 4.2 Docker Compose

```bash
docker-compose up -d
```

**docker-compose.yml**:
```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: your_password
      MYSQL_DATABASE: green_recycle
    volumes:
      - mysql_data:/var/lib/mysql
    ports:
      - "3306:3306"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build: ./docker/backend
    depends_on:
      - mysql
      - redis
    ports:
      - "8080:8080"

  frontend:
    build: ./docker/frontend
    ports:
      - "80:80"

volumes:
  mysql_data:
```

### 4.3 查看状态

```bash
# 查看容器
docker-compose ps

# 查看日志
docker-compose logs -f

# 重启服务
docker-compose restart

# 停止服务
docker-compose down
```

---

## 5. 配置说明

### 5.1 后端配置

**config.yaml**:
```yaml
server:
  port: 8080
  mode: release

database:
  driver: mysql
  host: localhost
  port: 3306
  user: root
  password: your_password
  database: green_recycle

redis:
  host: localhost
  port: 6379
  password: ""
  db: 0

jwt:
  secret: your_jwt_secret
  expire: 86400

wechat:
  appid: your_appid
  secret: your_secret
```

### 5.2 前端配置

**.env.production**:
```
VITE_API_BASE_URL=https://api.green-recycle.com
VITE_WECHAT_APPID=your_appid
```

### 5.3 环境变量

```bash
# 后端环境变量
export GIN_MODE=release
export DB_HOST=localhost
export DB_PASSWORD=your_password
export JWT_SECRET=your_secret
```

---

## 6. 常见问题

### 6.1 后端问题

**Q: 服务启动失败？**
```bash
# 查看日志
journalctl -u green-recycle-backend -f

# 检查端口占用
sudo lsof -i :8080

# 检查数据库连接
mysql -u root -p -e "SELECT 1"
```

**Q: 数据库连接失败？**
```bash
# 检查 MySQL 状态
sudo systemctl status mysql

# 检查用户权限
mysql -u root -p -e "SHOW GRANTS FOR 'green_recycle'@'localhost'"
```

### 6.2 前端问题

**Q: 构建失败？**
```bash
# 清理缓存
rm -rf node_modules package-lock.json
npm install

# 检查 Node 版本
node -v  # 需要 18+
```

**Q: 页面空白？**
```bash
# 查看浏览器控制台
# 检查 API 地址配置
# 检查 Nginx 配置
```

### 6.3 Docker 问题

**Q: 容器启动失败？**
```bash
# 查看日志
docker-compose logs backend

# 检查端口占用
sudo lsof -i :8080

# 重新构建
docker-compose build --no-cache
```

### 6.4 性能优化

**数据库优化**:
```sql
-- 添加索引
ALTER TABLE orders ADD INDEX idx_user_id (user_id);
ALTER TABLE orders ADD INDEX idx_status (status);

-- 优化查询
EXPLAIN SELECT * FROM orders WHERE user_id = 1;
```

**Redis 缓存**:
```go
// 缓存用户信息
key := fmt.Sprintf("user:%d", userID)
data, _ := redis.Get(key).Result()
```

**Nginx 优化**:
```nginx
# 开启 Gzip
gzip on;
gzip_types text/plain application/json application/javascript text/css;

# 静态资源缓存
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 30d;
    add_header Cache-Control "public, immutable";
}
```

---

**最后更新**: 2026-03-05
**版本**: v1.0.0
