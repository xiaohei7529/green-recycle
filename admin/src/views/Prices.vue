<template>
  <div class="prices">
    <h2>💰 价格管理</h2>
    
    <el-card>
      <el-button type="primary" style="margin-bottom: 20px">添加价格</el-button>
      <el-table :data="prices" style="width: 100%">
        <el-table-column prop="category" label="分类" />
        <el-table-column prop="name" label="名称" />
        <el-table-column prop="price" label="价格 (元/kg)" />
        <el-table-column prop="city" label="适用城市" />
        <el-table-column prop="effective_date" label="生效日期" />
        <el-table-column label="操作">
          <template #default="{ row }">
            <el-button size="small">编辑</el-button>
            <el-button size="small" type="danger">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const prices = ref([
  { category: '纸类', name: '报纸', price: 1.5, city: '全国', effective_date: '2026-03-06' },
  { category: '纸类', name: '纸箱', price: 1.2, city: '全国', effective_date: '2026-03-06' },
  { category: '金属', name: '铁', price: 3.5, city: '全国', effective_date: '2026-03-06' }
])
</script>

<style scoped>
.prices {
  padding: 20px;
}

.prices h2 {
  margin-bottom: 20px;
}
</style>
