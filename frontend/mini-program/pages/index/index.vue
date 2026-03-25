<template>
  <view class="container">
    <!-- 顶部欢迎区域 -->
    <view class="hero">
      <view class="hero-left">
        <view class="greeting">你好，{{ displayName }}</view>
        <view class="hero-sub">让回收更简单</view>
      </view>
      <view class="hero-icon">♻️</view>
    </view>

    <!-- 快速下单入口 -->
    <view class="quick-order" @click="goToOrderCreate">
      <view class="quick-icon">🚀</view>
      <view class="quick-content">
        <view class="quick-title">快速下单</view>
        <view class="quick-desc">上门回收，方便快捷</view>
      </view>
      <view class="quick-arrow">›</view>
    </view>

    <!-- 功能网格 -->
    <view class="section-title">功能入口</view>
    <view class="grid">
      <view class="grid-item" @click="switchToOrders">
        <view class="grid-icon">📦</view>
        <view class="grid-text">我的订单</view>
      </view>
      <view class="grid-item" @click="switchToPrices">
        <view class="grid-icon">💰</view>
        <view class="grid-text">回收价格</view>
      </view>
      <view class="grid-item" @click="switchToProfile">
        <view class="grid-icon">👤</view>
        <view class="grid-text">个人中心</view>
      </view>
      <view class="grid-item" @click="comingSoon">
        <view class="grid-icon">📍</view>
        <view class="grid-text">附近回收点</view>
      </view>
    </view>

    <!-- 公告 -->
    <view class="notice-card">
      <view class="notice-header">
        <text class="notice-dot">📢</text>
        <text class="notice-title">最新公告</text>
      </view>
      <view class="notice-content">回收价格每日更新，欢迎预约上门回收！</view>
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const displayName = computed(() => {
  const phone = authStore.userInfo?.phone
  if (phone && phone.length >= 11) return phone.slice(0, 3) + '****' + phone.slice(-4)
  return '朋友'
})

onShow(() => {
  if (!authStore.isLoggedIn) {
    uni.navigateTo({ url: '/pages/login/login' })
  }
})

const goToOrderCreate = () => {
  uni.navigateTo({ url: '/pages/order-create/order-create' })
}

const switchToOrders = () => {
  uni.switchTab({ url: '/pages/orders/orders' })
}

const switchToPrices = () => {
  uni.switchTab({ url: '/pages/prices/prices' })
}

const switchToProfile = () => {
  uni.switchTab({ url: '/pages/profile/profile' })
}

const comingSoon = () => {
  uni.showToast({ title: '功能即将上线', icon: 'none' })
}
</script>

<style scoped>
.container {
  padding: 0 24rpx 40rpx;
  background: #f5f7fa;
  min-height: 100vh;
}

.hero {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, #10B981, #059669);
  margin: 0 -24rpx;
  padding: 60rpx 40rpx 50rpx;
}

.greeting {
  font-size: 40rpx;
  font-weight: bold;
  color: #fff;
  margin-bottom: 10rpx;
}

.hero-sub {
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.85);
}

.hero-icon {
  font-size: 100rpx;
}

.quick-order {
  background: #fff;
  border-radius: 20rpx;
  padding: 36rpx;
  margin: 24rpx 0;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 16rpx rgba(16, 185, 129, 0.15);
  border-left: 8rpx solid #10B981;
}

.quick-icon {
  font-size: 64rpx;
  margin-right: 24rpx;
}

.quick-content {
  flex: 1;
}

.quick-title {
  font-size: 34rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 8rpx;
}

.quick-desc {
  font-size: 26rpx;
  color: #999;
}

.quick-arrow {
  font-size: 50rpx;
  color: #10B981;
  line-height: 1;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 16rpx;
}

.grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.grid-item {
  background: #fff;
  border-radius: 20rpx;
  padding: 40rpx 20rpx;
  text-align: center;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.06);
}

.grid-icon {
  font-size: 60rpx;
  margin-bottom: 14rpx;
}

.grid-text {
  font-size: 28rpx;
  color: #555;
}

.notice-card {
  background: #ecfdf5;
  border: 1rpx solid #a7f3d0;
  border-radius: 16rpx;
  padding: 28rpx 30rpx;
}

.notice-header {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;
}

.notice-dot {
  font-size: 28rpx;
  margin-right: 10rpx;
}

.notice-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #065f46;
}

.notice-content {
  font-size: 28rpx;
  color: #047857;
  line-height: 1.6;
}
</style>
