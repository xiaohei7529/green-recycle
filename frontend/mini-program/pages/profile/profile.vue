<template>
  <view class="container">
    <view class="header">👤 个人中心</view>

    <!-- 用户信息 -->
    <view class="user-card">
      <view class="avatar">😊</view>
      <view class="user-info">
        <view class="nickname">用户昵称</view>
        <view class="phone">138****8000</view>
      </view>
    </view>

    <!-- 统计数据 -->
    <view class="stats">
      <view class="stat-item">
        <view class="stat-value">1250</view>
        <view class="stat-label">积分</view>
      </view>
      <view class="stat-item">
        <view class="stat-value">15</view>
        <view class="stat-label">订单</view>
      </view>
      <view class="stat-item">
        <view class="stat-value">¥358.50</view>
        <view class="stat-label">收益</view>
      </view>
    </view>

    <!-- 功能列表 -->
    <view class="menu-list">
      <view class="menu-item" @click="goToPage('/pages/orders/orders')">
        <view class="menu-icon">📦</view>
        <view class="menu-text">我的订单</view>
        <view class="menu-arrow">></view>
      </view>
      <view class="menu-item">
        <view class="menu-icon">📍</view>
        <view class="menu-text">我的地址</view>
        <view class="menu-arrow">></view>
      </view>
      <view class="menu-item">
        <view class="menu-icon">🎁</view>
        <view class="menu-text">积分商城</view>
        <view class="menu-arrow">></view>
      </view>
      <view class="menu-item">
        <view class="menu-icon">🎧</view>
        <view class="menu-text">客服中心</view>
        <view class="menu-arrow">></view>
      </view>
      <view class="menu-item" @click="logout">
        <view class="menu-icon">🚪</view>
        <view class="menu-text">退出登录</view>
        <view class="menu-arrow">></view>
      </view>
    </view>
  </view>
</template>

<script setup>
const goToPage = (url) => {
  uni.navigateTo({ url })
}

const logout = () => {
  uni.showModal({
    title: '提示',
    content: '确定要退出登录吗？',
    success: (res) => {
      if (res.confirm) {
        uni.showToast({ title: '已退出', icon: 'success' })
      }
    }
  })
}
</script>

<style scoped>
.container {
  background: #f5f7fa;
  min-height: 100vh;
}

.header {
  font-size: 40rpx;
  font-weight: bold;
  text-align: center;
  padding: 40rpx 0;
  background: white;
}

.user-card {
  background: linear-gradient(135deg, #409EFF, #67C23A);
  padding: 60rpx 40rpx;
  display: flex;
  align-items: center;
}

.avatar {
  width: 120rpx;
  height: 120rpx;
  background: white;
  border-radius: 50%;
  text-align: center;
  line-height: 120rpx;
  font-size: 60rpx;
  margin-right: 30rpx;
}

.user-info {
  flex: 1;
}

.nickname {
  font-size: 36rpx;
  color: white;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.phone {
  font-size: 28rpx;
  color: rgba(255,255,255,0.8);
}

.stats {
  display: flex;
  background: white;
  margin: 20rpx;
  border-radius: 20rpx;
  padding: 40rpx 0;
}

.stat-item {
  flex: 1;
  text-align: center;
}

.stat-value {
  font-size: 40rpx;
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 10rpx;
}

.stat-label {
  font-size: 26rpx;
  color: #999;
}

.menu-list {
  background: white;
  margin: 20rpx;
  border-radius: 20rpx;
  overflow: hidden;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #eee;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-icon {
  font-size: 40rpx;
  margin-right: 20rpx;
}

.menu-text {
  flex: 1;
  font-size: 30rpx;
  color: #333;
}

.menu-arrow {
  color: #999;
  font-size: 28rpx;
}
</style>
