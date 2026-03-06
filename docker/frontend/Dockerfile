FROM node:18-alpine AS builder

WORKDIR /app

# 复制 package.json
COPY frontend/pc-web/package.json ./

# 安装依赖（使用淘宝镜像加速）
RUN npm config set registry https://registry.npmmirror.com && npm install

# 复制源代码
COPY frontend/pc-web/ ./

# 构建
RUN npm run build

# Nginx 阶段
FROM nginx:alpine

# 复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制 nginx 配置
COPY docker/frontend/nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
