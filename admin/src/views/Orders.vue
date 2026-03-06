<template>
  <div class="orders">
    <h2>📦 订单管理</h2>
    
    <el-card>
      <el-table :data="orders" style="width: 100%">
        <el-table-column prop="order_no" label="订单号" />
        <el-table-column prop="user_phone" label="用户" />
        <el-table-column prop="type" label="类型">
          <template #default="{ row }">
            {{ row.type === 1 ? '上门回收' : '站点回收' }}
          </template>
        </el-table-column>
        <el-table-column prop="total_amount" label="金额" />
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="下单时间" />
        <el-table-column label="操作">
          <template #default="{ row }">
            <el-button size="small">详情</el-button>
            <el-button size="small">处理</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const orders = ref([
  { order_no: 'ORD20260305001', user_phone: '138****8000', type: 1, total_amount: 15.5, status: 3, created_at: '2026-03-05 10:30' },
  { order_no: 'ORD20260305002', user_phone: '139****9000', type: 2, total_amount: 28.0, status: 0, created_at: '2026-03-05 11:20' }
])

const getStatusType = (status) => {
  const types = { 0: '', 1: 'warning', 2: 'primary', 3: 'success', 4: 'danger' }
  return types[status] || ''
}

const getStatusText = (status) => {
  const texts = { 0: '待接单', 1: '已接单', 2: '回收中', 3: '已完成', 4: '已取消' }
  return texts[status] || '未知'
}
</script>

<style scoped>
.orders {
  padding: 20px;
}

.orders h2 {
  margin-bottom: 20px;
}
</style>
