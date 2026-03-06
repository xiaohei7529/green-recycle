<template>
  <div class="order-detail">
    <van-card
      class="order-card"
      :title="order.order_no"
      :desc="order.type === 1 ? '上门回收' : '站点回收'"
    >
      <template #tags>
        <van-tag :type="getStatusType(order.status)">
          {{ getStatusText(order.status) }}
        </van-tag>
      </template>
    </van-card>

    <van-cell-group inset title="订单信息" style="margin-top: 20px">
      <van-cell title="下单时间" :value="order.created_at" />
      <van-cell title="上门时间" :value="order.pickup_time" />
      <van-cell title="联系人" :value="order.contact_name" />
      <van-cell title="联系电话" :value="order.contact_phone" />
      <van-cell title="地址" :value="order.address" />
    </van-cell-group>

    <van-cell-group inset title="废品明细" style="margin-top: 20px">
      <van-cell
        v-for="item in order.items"
        :key="item.id"
        :title="item.category"
        :value="`¥${item.price}/kg × ${item.weight}kg`"
      />
      <van-cell title="总重量" :value="`${order.total_weight}kg`" />
      <van-cell title="总金额" :value="`¥${order.total_amount}`" value-class="total-amount" />
    </van-cell-group>

    <van-action-bar>
      <van-action-bar-button v-if="order.status === 0" type="danger" text="取消订单" />
      <van-action-bar-button v-if="order.status === 1" type="primary" text="确认回收" />
    </van-action-bar>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { VanCard, VanCellGroup, VanCell, VanTag, VanActionBar, VanActionBarButton } from 'vant'

const order = ref({
  order_no: 'ORD20260305001',
  type: 1,
  status: 0,
  created_at: '2026-03-05 10:30:00',
  pickup_time: '2026-03-06 14:00:00',
  contact_name: '测试用户',
  contact_phone: '13800138000',
  address: '江苏省南通市如皋市 XX 小区 X 栋 X 单元',
  total_weight: 5.5,
  total_amount: 15.5,
  items: [
    { id: 1, category: '报纸', price: 1.5, weight: 3.0 },
    { id: 2, category: '纸箱', price: 1.2, weight: 2.5 }
  ]
})

const getStatusType = (status) => {
  const types = { 0: 'primary', 1: 'warning', 2: 'success', 3: 'success', 4: 'danger' }
  return types[status] || ''
}

const getStatusText = (status) => {
  const texts = { 0: '待接单', 1: '已接单', 2: '回收中', 3: '已完成', 4: '已取消' }
  return texts[status] || '未知'
}
</script>

<style scoped>
.order-detail {
  padding: 10px 0;
  background: #f5f5f5;
  min-height: 100vh;
  padding-bottom: 60px;
}

.order-card {
  margin: 10px;
}

.total-amount {
  color: #f56c6c;
  font-weight: bold;
  font-size: 18px;
}
</style>
