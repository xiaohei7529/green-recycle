<template>
  <div class="orders">
    <van-tabs v-model:active="active">
      <van-tab title="全部" :name="0" />
      <van-tab title="待接单" :name="1" />
      <van-tab title="回收中" :name="2" />
      <van-tab title="已完成" :name="3" />
    </van-tabs>

    <van-list
      v-model:loading="loading"
      :finished="finished"
      finished-text="没有更多了"
      @load="onLoad"
    >
      <van-card
        v-for="order in orders"
        :key="order.order_id"
        class="order-card"
        :title="order.order_no"
        :desc="order.type === 1 ? '上门回收' : '站点回收'"
        :price="order.total_amount.toFixed(2)"
        :num="1"
      >
        <template #tags>
          <van-tag :type="getStatusType(order.status)">
            {{ getStatusText(order.status) }}
          </van-tag>
        </template>
        <template #footer>
          <van-button size="mini" @click="viewDetail(order)">详情</van-button>
          <van-button v-if="order.status === 0" size="mini" type="danger">取消</van-button>
        </template>
      </van-card>
    </van-list>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { VanTabs, VanTab, VanList, VanCard, VanTag, VanButton } from 'vant'

const active = ref(0)
const loading = ref(false)
const finished = ref(false)
const orders = ref([])

const onLoad = () => {
  // 模拟加载订单
  setTimeout(() => {
    orders.value.push(
      { order_id: 1, order_no: 'ORD20260305001', type: 1, total_amount: 15.5, status: 3 },
      { order_id: 2, order_no: 'ORD20260304002', type: 2, total_amount: 28.0, status: 0 }
    )
    loading.value = false
    finished.value = true
  }, 1000)
}

const getStatusType = (status) => {
  const types = { 0: 'primary', 1: 'warning', 2: 'success', 3: 'success', 4: 'danger' }
  return types[status] || ''
}

const getStatusText = (status) => {
  const texts = { 0: '待接单', 1: '已接单', 2: '回收中', 3: '已完成', 4: '已取消' }
  return texts[status] || '未知'
}

const viewDetail = (order) => {
  // TODO: 跳转到订单详情
  console.log('查看订单详情:', order)
}
</script>

<style scoped>
.orders {
  padding-bottom: 20px;
}

.order-card {
  margin: 10px;
}
</style>
