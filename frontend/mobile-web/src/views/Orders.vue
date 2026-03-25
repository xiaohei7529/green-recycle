<template>
  <div class="orders">
    <van-nav-bar title="我的订单" />

    <van-tabs v-model:active="activeTab" @change="onTabChange">
      <van-tab title="全部" name="all" />
      <van-tab title="待接单" name="pending" />
      <van-tab title="回收中" name="processing" />
      <van-tab title="已完成" name="completed" />
    </van-tabs>

    <van-pull-refresh v-model="refreshing" @refresh="onRefresh">
      <van-list
        v-model:loading="loading"
        :finished="finished"
        finished-text="没有更多了"
        @load="onLoad"
      >
        <van-card
          v-for="order in displayOrders"
          :key="order.id"
          class="order-card"
          :title="order.order_no"
          :desc="order.type === 1 ? '上门回收' : '站点回收'"
        >
          <template #price>
            <span class="price-text">¥{{ Number(order.total_amount).toFixed(2) }}</span>
          </template>
          <template #tags>
            <van-tag plain :type="getStatusType(order.status)">
              {{ getStatusText(order.status) }}
            </van-tag>
          </template>
          <template #footer>
            <van-button size="mini" @click="viewDetail(order)">查看详情</van-button>
            <van-button
              v-if="order.status === 0"
              size="mini"
              type="danger"
              plain
              @click="onCancelOrder(order)"
            >
              取消订单
            </van-button>
          </template>
        </van-card>

        <van-empty v-if="!loading && displayOrders.length === 0" description="暂无订单" />
      </van-list>
    </van-pull-refresh>

    <van-button
      round
      type="primary"
      class="create-btn"
      icon="plus"
      @click="router.push('/order/create')"
    >
      创建订单
    </van-button>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { showConfirmDialog, showToast, showFailToast } from 'vant'
import { fetchOrders, cancelOrder } from '@/api/orders'
import { getStatusType, getStatusText } from '@/utils/orderStatus'

const router = useRouter()

const activeTab = ref('all')
const loading = ref(false)
const finished = ref(false)
const refreshing = ref(false)
const allOrders = ref([])

// 根据当前 Tab 过滤订单
const displayOrders = computed(() => {
  const statusMap = { pending: [0], processing: [1, 2], completed: [3] }
  if (activeTab.value === 'all') return allOrders.value
  const targets = statusMap[activeTab.value] || []
  return allOrders.value.filter(o => targets.includes(o.status))
})

const loadOrders = async () => {
  loading.value = true
  try {
    const res = await fetchOrders({ page: 1, page_size: 50 })
    allOrders.value = res.data?.list || []
  } catch (err) {
    showFailToast(err.message || '加载失败')
  } finally {
    loading.value = false
    finished.value = true
    refreshing.value = false
  }
}

const onLoad = () => {
  if (allOrders.value.length === 0) {
    loadOrders()
  } else {
    loading.value = false
    finished.value = true
  }
}

const onTabChange = () => {
  // Tab 切换在本地过滤，无需重新请求
}

const onRefresh = () => {
  finished.value = false
  allOrders.value = []
  loadOrders()
}

const viewDetail = (order) => {
  router.push(`/order/${order.id}`)
}

const onCancelOrder = async (order) => {
  try {
    await showConfirmDialog({
      title: '取消订单',
      message: `确定取消订单 ${order.order_no} 吗？`
    })
    await cancelOrder(order.id)
    showToast({ message: '已取消', type: 'success' })
    onRefresh()
  } catch (err) {
    if (err !== 'cancel') showFailToast(err.message || '取消失败')
  }
}
</script>

<style scoped>
.orders {
  padding-bottom: 80px;
  min-height: 100vh;
  background: #f5f5f5;
}

.order-card {
  margin: 10px 12px;
  border-radius: 12px;
}

.price-text {
  color: #ee0a24;
  font-weight: bold;
  font-size: 16px;
}

.create-btn {
  position: fixed;
  bottom: 70px;
  right: 20px;
  z-index: 100;
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
  --van-button-primary-background: #10B981;
  --van-button-primary-border-color: #10B981;
}
</style>
