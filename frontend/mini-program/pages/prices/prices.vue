<template>
  <view class="container">
    <view class="header">💰 回收价格</view>

    <view class="notice">价格每日更新，仅供参考</view>

    <view v-for="category in prices" :key="category.name" class="category">
      <view class="category-title">{{ category.name }}</view>
      <view v-for="item in category.items" :key="item.name" class="price-item">
        <view class="price-name">{{ item.name }}</view>
        <view class="price-value">¥{{ item.price }}/{{ item.unit }}</view>
      </view>
    </view>
  </view>
</template>

<script setup>
const prices = [
  {
    name: '纸类',
    items: [
      { name: '报纸', price: 1.5, unit: 'kg' },
      { name: '纸箱', price: 1.2, unit: 'kg' },
      { name: '书本', price: 1.8, unit: 'kg' }
    ]
  },
  {
    name: '塑料',
    items: [
      { name: 'PET 瓶', price: 2.0, unit: 'kg' },
      { name: 'PE 膜', price: 3.5, unit: 'kg' }
    ]
  },
  {
    name: '金属',
    items: [
      { name: '铁', price: 3.5, unit: 'kg' },
      { name: '铝', price: 12.0, unit: 'kg' },
      { name: '铜', price: 45.0, unit: 'kg' }
    ]
  },
  {
    name: '电器',
    items: [
      { name: '空调', price: 150.0, unit: '台' },
      { name: '冰箱', price: 100.0, unit: '台' }
    ]
  }
]
</script>

<style scoped>
.container {
  padding: 20rpx;
}

.header {
  font-size: 40rpx;
  font-weight: bold;
  text-align: center;
  padding: 40rpx 0;
}

.notice {
  background: #ECF5FF;
  color: #409EFF;
  padding: 20rpx;
  border-radius: 10rpx;
  text-align: center;
  margin-bottom: 30rpx;
}

.category {
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.1);
}

.category-title {
  font-size: 32rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
  color: #409EFF;
}

.price-item {
  display: flex;
  justify-content: space-between;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #eee;
}

.price-item:last-child {
  border-bottom: none;
}

.price-name {
  font-size: 28rpx;
  color: #333;
}

.price-value {
  font-size: 28rpx;
  color: #F56C6C;
  font-weight: bold;
}
</style>
