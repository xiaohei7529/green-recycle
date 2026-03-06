# 📙 Green Recycle - API 文档

---

## 基础信息

**Base URL**: `https://api.green-recycle.com`

**API 版本**: v1

**认证方式**: JWT Token

---

## 认证接口

### 1. 用户注册

```http
POST /api/v1/auth/register
Content-Type: application/json
```

**请求**:
```json
{
  "phone": "13800138000",
  "code": "123456",
  "password": "password123"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "user_id": 1001,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 2. 用户登录

```http
POST /api/v1/auth/login
Content-Type: application/json
```

**请求**:
```json
{
  "phone": "13800138000",
  "password": "password123"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "user_id": 1001,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 86400
  }
}
```

### 3. 微信登录

```http
POST /api/v1/auth/wechat
Content-Type: application/json
```

**请求**:
```json
{
  "code": "wx_auth_code"
}
```

---

## 用户接口

### 4. 获取用户信息

```http
GET /api/v1/user/profile
Authorization: Bearer {token}
```

**响应**:
```json
{
  "code": 200,
  "data": {
    "user_id": 1001,
    "phone": "138****8000",
    "nickname": "用户昵称",
    "avatar": "https://...",
    "points": 1250,
    "total_orders": 15,
    "total_income": 358.50
  }
}
```

### 5. 更新用户信息

```http
PUT /api/v1/user/profile
Authorization: Bearer {token}
Content-Type: application/json
```

**请求**:
```json
{
  "nickname": "新昵称",
  "avatar": "https://..."
}
```

---

## 订单接口

### 6. 创建订单

```http
POST /api/v1/orders
Authorization: Bearer {token}
Content-Type: application/json
```

**请求**:
```json
{
  "type": "pickup",
  "items": [
    {
      "category": "paper",
      "weight": 5.0,
      "price": 1.5
    }
  ],
  "address": {
    "province": "江苏省",
    "city": "南通市",
    "district": "如皋市",
    "detail": "XX 小区 X 栋 X 单元"
  },
  "contact": {
    "name": "张三",
    "phone": "13800138000"
  },
  "pickup_time": "2026-03-06 14:00:00"
}
```

**响应**:
```json
{
  "code": 200,
  "data": {
    "order_id": "ORD20260305001",
    "status": "pending"
  }
}
```

### 7. 订单列表

```http
GET /api/v1/orders?status=all&page=1&page_size=20
Authorization: Bearer {token}
```

**响应**:
```json
{
  "code": 200,
  "data": {
    "total": 15,
    "page": 1,
    "page_size": 20,
    "list": [
      {
        "order_id": "ORD20260305001",
        "status": "completed",
        "total_amount": 7.50,
        "created_at": "2026-03-05 10:30:00"
      }
    ]
  }
}
```

### 8. 订单详情

```http
GET /api/v1/orders/{order_id}
Authorization: Bearer {token}
```

### 9. 取消订单

```http
POST /api/v1/orders/{order_id}/cancel
Authorization: Bearer {token}
```

---

## 回收员接口

### 10. 回收员注册

```http
POST /api/v1/recycler/register
Content-Type: application/json
```

**请求**:
```json
{
  "name": "李四",
  "id_card": "320682199001011234",
  "phone": "13900139000",
  "service_areas": ["如皋市"]
}
```

### 11. 接单

```http
POST /api/v1/recycler/orders/{order_id}/accept
Authorization: Bearer {token}
```

### 12. 完成订单

```http
POST /api/v1/recycler/orders/{order_id}/complete
Authorization: Bearer {token}
Content-Type: application/json
```

**请求**:
```json
{
  "actual_weight": 5.5,
  "actual_amount": 8.25,
  "photos": ["url1", "url2"]
}
```

---

## 价格接口

### 13. 获取价格列表

```http
GET /api/v1/prices?category=all
```

**响应**:
```json
{
  "code": 200,
  "data": {
    "updated_at": "2026-03-05 08:00:00",
    "categories": [
      {
        "name": "纸类",
        "items": [
          {"name": "报纸", "price": 1.5, "unit": "kg"},
          {"name": "纸箱", "price": 1.2, "unit": "kg"},
          {"name": "书本", "price": 1.8, "unit": "kg"}
        ]
      }
    ]
  }
}
```

---

## 附近回收点

### 14. 获取附近回收点

```http
GET /api/v1/stations/nearby?lat=32.39&lng=120.57&radius=5000
```

**响应**:
```json
{
  "code": 200,
  "data": {
    "list": [
      {
        "station_id": 101,
        "name": "如皋回收站 A",
        "address": "如皋市 XX 路 XX 号",
        "distance": 1200,
        "rating": 4.8,
        "hours": "08:00-20:00"
      }
    ]
  }
}
```

---

## 错误码

| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

---

**最后更新**: 2026-03-05
**版本**: v1.0.0
