<template>
  <view class="container">
    <view class="header">📦 我的订单</view>

    <!-- 状态筛选 -->
    <view class="tabs">
      <view 
        v-for="tab in tabs" 
        :key="tab.value"
        :class="['tab', activeTab === tab.value ? 'active' : '']"
        @click="activeTab = tab.value"
      >
        {{ tab.label }}
      </view>
    </view>

    <!-- 订单列表 -->
    <view class="order-list">
      <view v-for="order in orders" :key="order.order_id" class="order-item" @click="viewDetail(order)">
        <view class="order-header">
          <text class="order-no">订单号：{{ order.order_no }}</text>
          <text :class="['status', getStatusClass(order.status)]">{{ getStatusText(order.status) }}</text>
        </view>
        <view class="order-body">
          <view class="order-info">
            <text>类型：{{ order.type === 1 ? '上门回收' : '站点回收' }}</text>
            <text>重量：{{ order.total_weight }}kg</text>
            <text>金额：¥{{ order.total_amount }}</text>
          </view>
        </view>
        <view class="order-footer">
          <text class="order-time">{{ order.created_at }}</text>
          <view class="order-actions">
            <button v-if="order.status === 0" class="btn-cancel" size="mini">取消</button>
            <button class="btn-detail" size="mini">详情</button>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'

const activeTab = ref('all')

const tabs = [
  { label: '全部', value: 'all' },
  { label: '待接单', value: 0 },
  { label: '回收中', value: 2 },
  { label: '已完成', value: 3 }
]

const orders = ref([
  { order_id: 1, order_no: 'ORD20260305001', type: 1, total_weight: 5.5, total_amount: 15.5, status: 3, created_at: '2026-03-05 10:30' },
  { order_id: 2, order_no: 'ORD20260304002', type: 2, total_weight: 10.0, total_amount: 28.0, status: 0, created_at: '2026-03-04 14:20' }
])

const getStatusClass = (status) => {
  const classes = { 0: 'pending', 1: 'accepted', 2: 'processing', 3: 'completed', 4: 'cancelled' }
  return classes[status] || ''
}

const getStatusText = (status) => {
  const texts = { 0: '待接单', 1: '已接单', 2: '回收中', 3: '已完成', 4: '已取消' }
  return texts[status] || '未知'
}

const viewDetail = (order) => {
  uni.showToast({ title: '查看订单详情', icon: 'none' })
}
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

.tabs {
  display: flex;
  background: white;
  border-radius: 20rpx;
  padding: 20rpx;
  margin-bottom: 20rpx;
}

.tab {
  flex: 1;
  text-align: center;
  padding: 20rpx;
  font-size: 28rpx;
  color: #666;
}

.tab.active {
  color: #409EFF;
  font-weight: bold;
  border-bottom: 4rpx solid #409EFF;
}

.order-item {
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.1);
}

.order-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20rpx;
}

.order-no {
  font-size: 28rpx;
  color: #666;
}

.status {
  font-size: 28rpx;
  color: #409EFF;
}

.status.pending { color: #E6A23C; }
.status.completed { color: #67C23A; }
.status.cancelled { color: #F56C6C; }

.order-body {
  margin-bottom: 20rpx;
}

.order-info text {
  display: block;
  font-size: 28rpx;
  margin-bottom: 10rpx;
  color: #333;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 1rpx solid #eee;
  padding-top: 20rpx;
}

.order-time {
  font-size: 24rpx;
  color: #999;
}

.order-actions {
  display: flex;
  gap: 20rpx;
}

.btn-cancel {
  background: #F56C6C;
  color: white;
}

.btn-detail {
  background: #409EFF;
  color: white;
}
</style>
