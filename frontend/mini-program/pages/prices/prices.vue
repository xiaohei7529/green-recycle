<template>
  <view class="container">
    <view class="notice-bar">
      <text class="notice-icon">📢</text>
      <text>价格每日更新，以实际回收为准</text>
    </view>

    <!-- 加载中 -->
    <view v-if="loading" class="empty-tip">加载中...</view>

    <!-- 空状态 -->
    <view v-else-if="categories.length === 0" class="empty-tip">
      <view>暂无价格数据</view>
    </view>

    <!-- 分类价格列表 -->
    <view v-else>
      <view v-for="cat in categories" :key="cat.name" class="category-card">
        <view class="category-title">
          <text class="cat-dot">●</text>
          <text>{{ cat.name }}</text>
        </view>
        <view v-for="item in cat.items" :key="item.name" class="price-row">
          <text class="price-name">{{ item.name }}</text>
          <text class="price-value">¥{{ item.price }}/{{ item.unit }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onShow, onPullDownRefresh } from '@dcloudio/uni-app'
import { fetchPrices } from '@/api/prices'

const loading = ref(false)
const categories = ref([])

const loadPrices = async () => {
  loading.value = true
  try {
    const res = await fetchPrices()
    const raw = res.prices ?? res ?? []
    // 按 category_name 分组
    const map = {}
    for (const item of raw) {
      const catName = item.category_name || item.category || '其他'
      if (!map[catName]) map[catName] = { name: catName, items: [] }
      map[catName].items.push({
        name: item.name,
        price: item.price,
        unit: item.unit || 'kg'
      })
    }
    categories.value = Object.values(map)
  } catch {
    // 错误在 request.js 内提示
  } finally {
    loading.value = false
  }
}

onShow(() => {
  loadPrices()
})

onPullDownRefresh(async () => {
  await loadPrices()
  uni.stopPullDownRefresh()
})
</script>

<style scoped>
.container {
  padding: 20rpx;
  background: #f5f7fa;
  min-height: 100vh;
}

.notice-bar {
  background: #ecfdf5;
  border: 1rpx solid #a7f3d0;
  color: #047857;
  padding: 20rpx 28rpx;
  border-radius: 14rpx;
  margin-bottom: 24rpx;
  display: flex;
  align-items: center;
  font-size: 26rpx;
}

.notice-icon {
  margin-right: 10rpx;
  font-size: 28rpx;
}

.empty-tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 80rpx 0;
}

.category-card {
  background: #fff;
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06);
}

.category-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #10B981;
  margin-bottom: 20rpx;
  display: flex;
  align-items: center;
}

.cat-dot {
  font-size: 20rpx;
  margin-right: 10rpx;
  color: #10B981;
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.price-row:last-child {
  border-bottom: none;
}

.price-name {
  font-size: 28rpx;
  color: #444;
}

.price-value {
  font-size: 30rpx;
  font-weight: bold;
  color: #ef4444;
}
</style>
