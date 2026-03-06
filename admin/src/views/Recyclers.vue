<template>
  <div class="recyclers">
    <h2>🚚 回收员管理</h2>
    
    <el-card>
      <el-table :data="recyclers" style="width: 100%">
        <el-table-column prop="recycler_id" label="回收员 ID" />
        <el-table-column prop="name" label="姓名" />
        <el-table-column prop="phone" label="电话" />
        <el-table-column prop="service_areas" label="服务区域" />
        <el-table-column prop="rating" label="评分">
          <template #default="{ row }">
            <el-rate v-model="row.rating" disabled />
          </template>
        </el-table-column>
        <el-table-column prop="total_orders" label="总订单" />
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template #default="{ row }">
            <el-button size="small">审核</el-button>
            <el-button size="small">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const recyclers = ref([
  { recycler_id: 1, name: '张三', phone: '13900139000', service_areas: '如皋市', rating: 4.8, total_orders: 158, status: 1 },
  { recycler_id: 2, name: '李四', phone: '13700137000', service_areas: '如皋市', rating: 4.9, total_orders: 203, status: 1 }
])

const getStatusType = (status) => {
  const types = { 0: 'warning', 1: 'success', 2: 'danger' }
  return types[status] || ''
}

const getStatusText = (status) => {
  const texts = { 0: '待审核', 1: '已启用', 2: '已禁用' }
  return texts[status] || '未知'
}
</script>

<style scoped>
.recyclers {
  padding: 20px;
}

.recyclers h2 {
  margin-bottom: 20px;
}
</style>
