<template>
  <div class="order-detail">
    <van-nav-bar
      title="订单详情"
      left-arrow
      @click-left="router.back()"
    />

    <van-loading v-if="loading" class="page-loading" size="40" vertical>加载中...</van-loading>

    <template v-else-if="order">
      <van-card class="order-card" :title="order.order_no">
        <template #desc>
          <span>{{ order.type === 1 ? '上门回收' : '站点回收' }}</span>
        </template>
        <template #tags>
          <van-tag plain :type="getStatusType(order.status)">
            {{ getStatusText(order.status) }}
          </van-tag>
        </template>
      </van-card>

      <van-cell-group inset title="订单信息" class="info-group">
        <van-cell title="下单时间" :value="formatTime(order.created_at)" />
        <van-cell title="预约时间" :value="formatTime(order.pickup_time)" />
        <van-cell title="联系人" :value="order.contact_name" />
        <van-cell title="联系电话" :value="order.contact_phone" />
        <van-cell
          title="上门地址"
          :value="[order.province, order.city, order.district, order.address].filter(Boolean).join(' ')"
        />
      </van-cell-group>

      <van-cell-group inset title="废品明细" class="info-group">
        <van-cell
          v-for="item in order.order_items"
          :key="item.id"
          :title="item.category"
          :value="`¥${item.price}/kg × ${item.weight}kg = ¥${item.amount}`"
        />
        <van-cell title="总重量" :value="`${order.total_weight} kg`" />
        <van-cell title="应付金额">
          <template #value>
            <span class="total-amount">¥{{ Number(order.total_amount).toFixed(2) }}</span>
          </template>
        </van-cell>
      </van-cell-group>

      <van-action-bar v-if="order.status === 0">
        <van-action-bar-button
          type="danger"
          text="取消订单"
          :loading="cancelling"
          @click="onCancel"
        />
      </van-action-bar>
    </template>

    <van-empty v-else description="订单不存在" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { showConfirmDialog, showToast, showFailToast } from 'vant'
import { fetchOrderDetail, cancelOrder } from '@/api/orders'
import { getStatusType, getStatusText } from '@/utils/orderStatus'

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const cancelling = ref(false)
const order = ref(null)

const formatTime = (val) => {
  if (!val) return '-'
  return String(val).replace('T', ' ').slice(0, 16)
}

const loadOrder = async () => {
  loading.value = true
  try {
    const res = await fetchOrderDetail(route.params.id)
    order.value = res.data
  } catch (err) {
    showFailToast(err.message || '获取订单失败')
  } finally {
    loading.value = false
  }
}

const onCancel = async () => {
  try {
    await showConfirmDialog({ title: '取消订单', message: '确定要取消此订单吗？' })
    cancelling.value = true
    await cancelOrder(route.params.id)
    showToast({ message: '已取消', type: 'success' })
    order.value.status = 4
  } catch (err) {
    if (err !== 'cancel') showFailToast(err.message || '取消失败')
  } finally {
    cancelling.value = false
  }
}

onMounted(loadOrder)
</script>

<style scoped>
.order-detail {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 70px;
}

.page-loading {
  display: flex;
  justify-content: center;
  padding-top: 80px;
}

.order-card {
  margin: 12px;
  border-radius: 12px;
}

.info-group {
  margin-top: 12px;
}

.total-amount {
  color: #ee0a24;
  font-weight: bold;
  font-size: 18px;
}
</style>
