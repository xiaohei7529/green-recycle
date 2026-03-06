<template>
  <div class="orders">
    <h2>📦 我的订单</h2>
    <el-tabs v-model="activeTab">
      <el-tab-pane label="全部" name="all" />
      <el-tab-pane label="待接单" name="pending" />
      <el-tab-pane label="回收中" name="processing" />
      <el-tab-pane label="已完成" name="completed" />
    </el-tabs>
    
    <el-table :data="orders" style="width: 100%">
      <el-table-column prop="orderNo" label="订单号" />
      <el-table-column prop="type" label="类型">
        <template #default="{ row }">
          {{ row.type === 1 ? '上门回收' : '站点回收' }}
        </template>
      </el-table-column>
      <el-table-column prop="totalAmount" label="金额" />
      <el-table-column prop="status" label="状态">
        <template #default="{ row }">
          <el-tag :type="getStatusType(row.status)">
            {{ getStatusText(row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createdAt" label="下单时间" />
      <el-table-column label="操作">
        <template #default="{ row }">
          <el-button size="small" @click="viewDetail(row)">详情</el-button>
          <el-button v-if="row.status === 0" size="small" type="danger">取消</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const activeTab = ref('all')

const orders = ref([
  { orderNo: 'ORD20260305001', type: 1, totalAmount: 15.5, status: 3, createdAt: '2026-03-05 10:30' },
  { orderNo: 'ORD20260304002', type: 2, totalAmount: 28.0, status: 0, createdAt: '2026-03-04 14:20' }
])

const getStatusType = (status) => {
  const types = { 0: '', 1: 'warning', 2: 'primary', 3: 'success', 4: 'danger' }
  return types[status] || ''
}

const getStatusText = (status) => {
  const texts = { 0: '待接单', 1: '已接单', 2: '回收中', 3: '已完成', 4: '已取消' }
  return texts[status] || '未知'
}

const viewDetail = (order) => {
  console.log('查看订单详情:', order)
}
</script>
