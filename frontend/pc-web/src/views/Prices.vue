<template>
  <div class="prices">
    <el-header class="header">
      <div class="logo">♻️ Green Recycle</div>
      <el-menu mode="horizontal" :ellipsis="false" router :default-active="$route.path">
        <el-menu-item index="/">首页</el-menu-item>
        <el-menu-item index="/orders">订单</el-menu-item>
        <el-menu-item index="/prices">价格</el-menu-item>
        <el-menu-item index="/profile">我的</el-menu-item>
      </el-menu>
    </el-header>

    <el-main>
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
    </el-main>
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
  min-height: 100vh;
}

.header {
  display: flex;
  align-items: center;
  background: #409EFF;
  color: white;
}

.logo {
  font-size: 24px;
  font-weight: bold;
  margin-right: 40px;
}

.prices h2 {
  margin-bottom: 20px;
}
</style>
