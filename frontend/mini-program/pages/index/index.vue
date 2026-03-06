<template>
  <view class="container">
    <!-- 顶部 -->
    <view class="header">
      <text class="title">♻️ Green Recycle</text>
    </view>

    <!-- 快速下单 -->
    <view class="quick-order" @click="goToOrder">
      <view class="icon">🚀</view>
      <view class="text">快速下单</view>
    </view>

    <!-- 功能网格 -->
    <view class="grid">
      <view class="grid-item" @click="goToPage('/pages/orders/orders')">
        <view class="grid-icon">📦</view>
        <view class="grid-text">我的订单</view>
      </view>
      <view class="grid-item" @click="goToPage('/pages/prices/prices')">
        <view class="grid-icon">💰</view>
        <view class="grid-text">回收价格</view>
      </view>
      <view class="grid-item" @click="goToPage('/pages/profile/profile')">
        <view class="grid-icon">👤</view>
        <view class="grid-text">个人中心</view>
      </view>
      <view class="grid-item">
        <view class="grid-icon">📍</view>
        <view class="grid-text">附近回收点</view>
      </view>
    </view>

    <!-- 公告 -->
    <view class="notice">
      <view class="notice-title">📢 最新公告</view>
      <view class="notice-content">回收价格每日更新，欢迎下单！</view>
    </view>
  </view>
</template>

<script setup>
const goToOrder = () => {
  uni.navigateTo({ url: '/pages/orders/orders' })
}

const goToPage = (url) => {
  uni.navigateTo({ url })
}
</script>

<style scoped>
.container {
  padding: 20rpx;
}

.header {
  text-align: center;
  padding: 40rpx 0;
}

.title {
  font-size: 48rpx;
  font-weight: bold;
}

.quick-order {
  background: linear-gradient(135deg, #409EFF, #67C23A);
  border-radius: 20rpx;
  padding: 60rpx;
  text-align: center;
  color: white;
  margin-bottom: 40rpx;
}

.quick-order .icon {
  font-size: 80rpx;
  margin-bottom: 20rpx;
}

.quick-order .text {
  font-size: 36rpx;
  font-weight: bold;
}

.grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20rpx;
  margin-bottom: 40rpx;
}

.grid-item {
  background: white;
  border-radius: 20rpx;
  padding: 40rpx;
  text-align: center;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.1);
}

.grid-icon {
  font-size: 60rpx;
  margin-bottom: 10rpx;
}

.grid-text {
  font-size: 28rpx;
  color: #666;
}

.notice {
  background: #FEF0F0;
  border-radius: 20rpx;
  padding: 30rpx;
}

.notice-title {
  font-size: 32rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.notice-content {
  font-size: 28rpx;
  color: #666;
}
</style>
