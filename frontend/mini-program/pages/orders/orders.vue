<template>
  <view class="container">
    <!-- 状态 Tab -->
    <view class="tabs">
      <view
        v-for="tab in tabs"
        :key="tab.value"
        :class="['tab', activeTab === tab.value ? 'active' : '']"
        @click="activeTab = tab.value"
      >{{ tab.label }}</view>
    </view>

    <!-- 加载中 -->
    <view v-if="loading" class="empty-tip">加载中...</view>

    <!-- 空状态 -->
    <view v-else-if="filteredOrders.length === 0" class="empty-tip">
      <view class="empty-icon">📭</view>
      <view>暂无订单</view>
    </view>

    <!-- 订单列表 -->
    <view v-else class="order-list">
      <view
        v-for="order in filteredOrders"
        :key="order.order_id"
        class="order-item"
        @click="viewDetail(order)"
      >
        <view class="order-header">
          <text class="order-no">{{ order.order_no }}</text>
          <text :class="['status', statusClass(order.status)]">{{ statusText(order.status) }}</text>
        </view>
        <view class="order-body">
          <text class="order-info-line">类型：{{ order.type === 1 ? '上门回收' : '站点回收' }}</text>
          <text class="order-info-line">预约时间：{{ order.pickup_time || '-' }}</text>
          <view class="order-amount-row">
            <text class="order-weight">重量：{{ order.total_weight ?? '-' }} kg</text>
            <text class="order-amount">¥ {{ order.total_amount ?? '-' }}</text>
          </view>
        </view>
        <view class="order-footer">
          <text class="order-time">{{ order.created_at }}</text>
          <view class="order-actions" @click.stop>
            <button
              v-if="order.status === 0"
              class="btn-cancel"
              size="mini"
              @click="handleCancel(order)"
            >取消</button>
            <button class="btn-detail" size="mini" @click="viewDetail(order)">详情</button>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onShow, onPullDownRefresh } from '@dcloudio/uni-app'
import { useAuthStore } from '@/stores/auth'
import { fetchOrders, cancelOrder } from '@/api/orders'

const authStore = useAuthStore()
const loading = ref(false)
const orders = ref([])
const activeTab = ref('all')

const tabs = [
  { label: '全部', value: 'all' },
  { label: '待接单', value: 0 },
  { label: '回收中', value: 2 },
  { label: '已完成', value: 3 },
  { label: '已取消', value: 4 }
]

const statusText = (s) => ({ 0: '待接单', 1: '已接单', 2: '回收中', 3: '已完成', 4: '已取消' }[s] ?? '未知')
const statusClass = (s) => ({ 0: 'pending', 1: 'accepted', 2: 'processing', 3: 'completed', 4: 'cancelled' }[s] ?? '')

const filteredOrders = computed(() => {
  if (activeTab.value === 'all') return orders.value
  return orders.value.filter(o => o.status === activeTab.value)
})

const loadOrders = async () => {
  if (!authStore.isLoggedIn) return
  loading.value = true
  try {
    const res = await fetchOrders()
    orders.value = res.orders ?? res ?? []
  } catch {
    // 错误在 request.js 内提示
  } finally {
    loading.value = false
  }
}

onShow(() => {
  if (!authStore.isLoggedIn) {
    uni.navigateTo({ url: '/pages/login/login' })
    return
  }
  loadOrders()
})

onPullDownRefresh(async () => {
  await loadOrders()
  uni.stopPullDownRefresh()
})

const viewDetail = (order) => {
  uni.navigateTo({ url: `/pages/order-detail/order-detail?id=${order.order_id}` })
}

const handleCancel = (order) => {
  uni.showModal({
    title: '取消订单',
    content: '确定要取消该订单吗？',
    confirmColor: '#ef4444',
    async success(res) {
      if (!res.confirm) return
      try {
        await cancelOrder(order.order_id)
        uni.showToast({ title: '已取消', icon: 'success' })
        loadOrders()
      } catch {
        // 错误在 request.js 内提示
      }
    }
  })
}
</script>

<style scoped>
.container {
  padding: 20rpx;
  background: #f5f7fa;
  min-height: 100vh;
}

.tabs {
  display: flex;
  background: #fff;
  border-radius: 20rpx;
  padding: 10rpx 16rpx;
  margin-bottom: 24rpx;
  overflow-x: auto;
}

.tab {
  flex-shrink: 0;
  padding: 18rpx 24rpx;
  font-size: 26rpx;
  color: #666;
  white-space: nowrap;
  position: relative;
}

.tab.active {
  color: #10B981;
  font-weight: bold;
}

.tab.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20%;
  width: 60%;
  height: 4rpx;
  background: #10B981;
  border-radius: 2rpx;
}

.empty-tip {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 0;
  color: #999;
  font-size: 28rpx;
}

.empty-icon {
  font-size: 100rpx;
  margin-bottom: 20rpx;
}

.order-item {
  background: #fff;
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
  padding-bottom: 20rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.order-no {
  font-size: 24rpx;
  color: #999;
}

.status { font-size: 26rpx; font-weight: bold; }
.status.pending   { color: #f59e0b; }
.status.accepted  { color: #3b82f6; }
.status.processing{ color: #8b5cf6; }
.status.completed { color: #10B981; }
.status.cancelled { color: #ef4444; }

.order-body {
  margin-bottom: 20rpx;
}

.order-info-line {
  display: block;
  font-size: 28rpx;
  color: #555;
  margin-bottom: 10rpx;
}

.order-amount-row {
  display: flex;
  justify-content: space-between;
  margin-top: 10rpx;
}

.order-weight {
  font-size: 28rpx;
  color: #555;
}

.order-amount {
  font-size: 32rpx;
  font-weight: bold;
  color: #10B981;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20rpx;
  border-top: 1rpx solid #f0f0f0;
}

.order-time {
  font-size: 24rpx;
  color: #bbb;
}

.order-actions {
  display: flex;
  gap: 16rpx;
}

.btn-cancel {
  background: #fee2e2;
  color: #ef4444;
  border: none;
  font-size: 24rpx;
}

.btn-detail {
  background: #d1fae5;
  color: #10B981;
  border: none;
  font-size: 24rpx;
}
</style>
