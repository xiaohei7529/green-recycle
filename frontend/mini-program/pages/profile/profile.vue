<template>
  <view class="container">
    <!-- 用户信息卡片 -->
    <view class="user-card">
      <view class="avatar">
        <text>{{ avatarChar }}</text>
      </view>
      <view class="user-info">
        <view class="user-phone">{{ maskedPhone }}</view>
        <view class="user-tag">普通用户</view>
      </view>
    </view>

    <!-- 统计数据 -->
    <view class="stats-card">
      <view class="stat-item">
        <view class="stat-value">{{ userInfo?.points ?? 0 }}</view>
        <view class="stat-label">积分</view>
      </view>
      <view class="stat-divider"></view>
      <view class="stat-item">
        <view class="stat-value">-</view>
        <view class="stat-label">订单</view>
      </view>
      <view class="stat-divider"></view>
      <view class="stat-item">
        <view class="stat-value">-</view>
        <view class="stat-label">收益</view>
      </view>
    </view>

    <!-- 功能菜单 -->
    <view class="menu-card">
      <view class="menu-item" @click="switchToOrders">
        <text class="menu-icon">📦</text>
        <text class="menu-text">我的订单</text>
        <text class="menu-arrow">›</text>
      </view>
      <view class="menu-item" @click="comingSoon">
        <text class="menu-icon">📍</text>
        <text class="menu-text">我的地址</text>
        <text class="menu-arrow">›</text>
      </view>
      <view class="menu-item" @click="comingSoon">
        <text class="menu-icon">🎁</text>
        <text class="menu-text">积分商城</text>
        <text class="menu-arrow">›</text>
      </view>
      <view class="menu-item" @click="comingSoon">
        <text class="menu-icon">🎧</text>
        <text class="menu-text">客服中心</text>
        <text class="menu-arrow">›</text>
      </view>
    </view>

    <view class="menu-card">
      <view class="menu-item logout-item" @click="handleLogout">
        <text class="menu-icon">🚪</text>
        <text class="menu-text logout-text">退出登录</text>
        <text class="menu-arrow">›</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const userInfo = computed(() => authStore.userInfo)

const maskedPhone = computed(() => {
  const phone = userInfo.value?.phone || ''
  if (phone.length >= 11) return phone.slice(0, 3) + '****' + phone.slice(-4)
  return phone || '未设置'
})

const avatarChar = computed(() => {
  const phone = userInfo.value?.phone || ''
  return phone ? phone.slice(-1) : '我'
})

onShow(() => {
  if (!authStore.isLoggedIn) {
    uni.navigateTo({ url: '/pages/login/login' })
  }
})

const switchToOrders = () => {
  uni.switchTab({ url: '/pages/orders/orders' })
}

const comingSoon = () => {
  uni.showToast({ title: '功能即将上线', icon: 'none' })
}

const handleLogout = () => {
  uni.showModal({
    title: '退出登录',
    content: '确定要退出登录吗？',
    confirmColor: '#ef4444',
    success(res) {
      if (!res.confirm) return
      authStore.logout()
      uni.reLaunch({ url: '/pages/login/login' })
    }
  })
}
</script>

<style scoped>
.container {
  background: #f5f7fa;
  min-height: 100vh;
}

.user-card {
  background: linear-gradient(135deg, #10B981, #059669);
  padding: 60rpx 40rpx;
  display: flex;
  align-items: center;
}

.avatar {
  width: 120rpx;
  height: 120rpx;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 48rpx;
  color: #fff;
  font-weight: bold;
  margin-right: 30rpx;
  flex-shrink: 0;
}

.user-phone {
  font-size: 36rpx;
  color: #fff;
  font-weight: bold;
  margin-bottom: 12rpx;
}

.user-tag {
  display: inline-block;
  background: rgba(255, 255, 255, 0.25);
  color: #fff;
  font-size: 22rpx;
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
}

.stats-card {
  display: flex;
  background: #fff;
  margin: 20rpx;
  border-radius: 20rpx;
  padding: 40rpx 0;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06);
}

.stat-item {
  flex: 1;
  text-align: center;
}

.stat-value {
  font-size: 40rpx;
  font-weight: bold;
  color: #10B981;
  margin-bottom: 10rpx;
}

.stat-label {
  font-size: 26rpx;
  color: #999;
}

.stat-divider {
  width: 1rpx;
  background: #eee;
  margin: 10rpx 0;
}

.menu-card {
  background: #fff;
  margin: 0 20rpx 20rpx;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06);
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 32rpx 30rpx;
  border-bottom: 1rpx solid #f5f5f5;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-icon {
  font-size: 40rpx;
  margin-right: 20rpx;
  width: 50rpx;
  text-align: center;
}

.menu-text {
  flex: 1;
  font-size: 30rpx;
  color: #333;
}

.menu-arrow {
  color: #ccc;
  font-size: 40rpx;
  line-height: 1;
}

.logout-text {
  color: #ef4444;
}
</style>
