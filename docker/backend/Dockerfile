FROM golang:1.21-alpine AS builder

WORKDIR /app

# 安装依赖
RUN apk add --no-cache git

# 复制 go.mod
COPY backend/go.mod ./
RUN go mod download

# 复制源代码
COPY backend/ ./

# 编译
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o main cmd/main.go

# 运行阶段
FROM alpine:latest

WORKDIR /app

# 安装 ca 证书和时区
RUN apk --no-cache add ca-certificates tzdata

# 从构建阶段复制二进制文件
COPY --from=builder /app/main .

# 暴露端口
EXPOSE 8080

# 启动服务
CMD ["./main"]
