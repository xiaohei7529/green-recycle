<template>
  <view class="container">
    <!-- 加载中 -->
    <view v-if="loading" class="loading-tip">加载中...</view>

    <!-- 订单详情 -->
    <view v-else-if="order">
      <!-- 状态卡片 -->
      <view :class="['status-card', statusClass(order.status)]">
        <view class="status-text">{{ statusText(order.status) }}</view>
        <view class="status-desc">{{ statusDesc(order.status) }}</view>
      </view>

      <!-- 订单信息 -->
      <view class="info-card">
        <view class="card-title">订单信息</view>
        <view class="info-row">
          <text class="info-label">订单号</text>
          <text class="info-value small">{{ order.order_no }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">回收类型</text>
          <text class="info-value">{{ order.type === 1 ? '上门回收' : '站点回收' }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">联系人</text>
          <text class="info-value">{{ order.contact_name }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">联系电话</text>
          <text class="info-value">{{ order.contact_phone }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">回收地址</text>
          <text class="info-value">{{ order.address }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">预约时间</text>
          <text class="info-value">{{ order.pickup_time }}</text>
        </view>
        <view v-if="order.remarks" class="info-row">
          <text class="info-label">备注</text>
          <text class="info-value">{{ order.remarks }}</text>
        </view>
      </view>

      <!-- 费用信息 -->
      <view class="info-card">
        <view class="card-title">费用信息</view>
        <view class="info-row">
          <text class="info-label">预计重量</text>
          <text class="info-value">{{ order.total_weight != null ? order.total_weight + ' kg' : '待确认' }}</text>
        </view>
        <view class="info-row amount-row">
          <text class="info-label">实际金额</text>
          <text class="amount-value">{{ order.total_amount != null ? '¥' + order.total_amount : '待确认' }}</text>
        </view>
      </view>

      <!-- 时间信息 -->
      <view class="info-card">
        <view class="card-title">时间记录</view>
        <view class="info-row">
          <text class="info-label">下单时间</text>
          <text class="info-value">{{ order.created_at }}</text>
        </view>
        <view v-if="order.updated_at" class="info-row">
          <text class="info-label">更新时间</text>
          <text class="info-value">{{ order.updated_at }}</text>
        </view>
      </view>

      <!-- 操作按钮 -->
      <view v-if="order.status === 0" class="action-area">
        <button class="btn-cancel" :disabled="cancelling" @click="handleCancel">
          {{ cancelling ? '取消中...' : '取消订单' }}
        </button>
      </view>
    </view>

    <!-- 错误状态 -->
    <view v-else class="loading-tip">
      <view>订单不存在或已删除</view>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { fetchOrderDetail, cancelOrder } from '@/api/orders'

const loading = ref(true)
const cancelling = ref(false)
const order = ref(null)
let orderId = null

onLoad((options) => {
  orderId = options.id
  if (!orderId) {
    loading.value = false
    return
  }
  loadDetail()
})

const loadDetail = async () => {
  loading.value = true
  try {
    const res = await fetchOrderDetail(orderId)
    order.value = res.order ?? res
  } catch {
    order.value = null
  } finally {
    loading.value = false
  }
}

const statusText = (s) => ({ 0: '待接单', 1: '已接单', 2: '回收中', 3: '已完成', 4: '已取消' }[s] ?? '未知')
const statusClass = (s) => ({ 0: 'st-pending', 1: 'st-accepted', 2: 'st-processing', 3: 'st-completed', 4: 'st-cancelled' }[s] ?? '')
const statusDesc = (s) => ({
  0: '您的订单已提交，等待回收员接单',
  1: '回收员已接单，即将上门',
  2: '回收员正在处理您的订单',
  3: '订单已完成，感谢您的参与！',
  4: '订单已取消'
}[s] ?? '')

const handleCancel = () => {
  uni.showModal({
    title: '取消订单',
    content: '确定要取消该订单吗？',
    confirmColor: '#ef4444',
    async success(res) {
      if (!res.confirm) return
      cancelling.value = true
      try {
        await cancelOrder(orderId)
        uni.showToast({ title: '已取消', icon: 'success' })
        setTimeout(() => uni.navigateBack(), 1000)
      } catch {
        // 错误在 request.js 内提示
      } finally {
        cancelling.value = false
      }
    }
  })
}
</script>

<style scoped>
.container {
  padding: 24rpx;
  background: #f5f7fa;
  min-height: 100vh;
}

.loading-tip {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 0;
  color: #999;
  font-size: 28rpx;
  gap: 20rpx;
}

.status-card {
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  margin-bottom: 20rpx;
  text-align: center;
}

.st-pending   { background: #fffbeb; }
.st-accepted  { background: #eff6ff; }
.st-processing{ background: #f5f3ff; }
.st-completed { background: #ecfdf5; }
.st-cancelled { background: #fef2f2; }

.status-text {
  font-size: 40rpx;
  font-weight: bold;
  margin-bottom: 12rpx;
}

.st-pending   .status-text { color: #f59e0b; }
.st-accepted  .status-text { color: #3b82f6; }
.st-processing .status-text{ color: #8b5cf6; }
.st-completed .status-text { color: #10B981; }
.st-cancelled .status-text { color: #ef4444; }

.status-desc {
  font-size: 26rpx;
  color: #666;
}

.info-card {
  background: #fff;
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06);
}

.card-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
  padding-bottom: 20rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 16rpx 0;
  border-bottom: 1rpx solid #f9f9f9;
}

.info-row:last-child {
  border-bottom: none;
}

.info-label {
  font-size: 28rpx;
  color: #999;
  flex-shrink: 0;
  margin-right: 20rpx;
}

.info-value {
  font-size: 28rpx;
  color: #333;
  text-align: right;
  flex: 1;
}

.info-value.small {
  font-size: 24rpx;
  color: #666;
}

.amount-row {
  padding-top: 20rpx;
}

.amount-value {
  font-size: 36rpx;
  font-weight: bold;
  color: #10B981;
}

.action-area {
  padding: 10rpx 0 30rpx;
}

.btn-cancel {
  width: 100%;
  background: #fee2e2;
  color: #ef4444;
  border-radius: 50rpx;
  padding: 32rpx 0;
  font-size: 32rpx;
  font-weight: bold;
  text-align: center;
  border: none;
}

.btn-cancel[disabled] {
  opacity: 0.6;
}
</style>
