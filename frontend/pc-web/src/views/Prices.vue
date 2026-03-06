<template>
  <div class="prices">
    <h2>💰 回收价格</h2>
    <el-alert title="价格每日更新，仅供参考" type="info" :closable="false" show-icon />
    
    <el-table :data="prices" style="width: 100%; margin-top: 20px">
      <el-table-column prop="category" label="分类" />
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="price" label="价格 (元/kg)">
        <template #default="{ row }">
          <span style="color: #f56c6c; font-weight: bold">¥{{ row.price }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="updatedAt" label="更新时间" />
    </el-table>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const prices = ref([
  { category: '纸类', name: '报纸', price: 1.5, updatedAt: '2026-03-05 08:00' },
  { category: '纸类', name: '纸箱', price: 1.2, updatedAt: '2026-03-05 08:00' },
  { category: '纸类', name: '书本', price: 1.8, updatedAt: '2026-03-05 08:00' },
  { category: '塑料', name: 'PET 瓶', price: 2.0, updatedAt: '2026-03-05 08:00' },
  { category: '金属', name: '铁', price: 3.5, updatedAt: '2026-03-05 08:00' },
  { category: '金属', name: '铜', price: 45.0, updatedAt: '2026-03-05 08:00' }
])
</script>

<style scoped>
.prices {
  padding: 20px;
}
</style>
