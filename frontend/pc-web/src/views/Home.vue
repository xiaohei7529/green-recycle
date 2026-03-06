<template>
  <div class="home">
    <!-- 顶部导航 -->
    <el-header class="header">
      <div class="logo">♻️ Green Recycle</div>
      <el-menu mode="horizontal" :ellipsis="false" router>
        <el-menu-item index="/">首页</el-menu-item>
        <el-menu-item index="/orders">订单</el-menu-item>
        <el-menu-item index="/prices">价格</el-menu-item>
        <el-menu-item index="/profile">我的</el-menu-item>
        <el-menu-item index="/login" style="margin-left: auto">登录</el-menu-item>
      </el-menu>
    </el-header>

    <!-- 主要内容 -->
    <el-main>
      <!-- 快速下单 -->
      <el-card class="quick-order">
        <h2>🚀 快速下单</h2>
        <el-form :model="orderForm" label-width="100px">
          <el-form-item label="废品类型">
            <el-select v-model="orderForm.type" placeholder="请选择">
              <el-option label="纸类" value="paper" />
              <el-option label="塑料" value="plastic" />
              <el-option label="金属" value="metal" />
              <el-option label="电器" value="electronic" />
            </el-select>
          </el-form-item>
          <el-form-item label="预估重量">
            <el-input-number v-model="orderForm.weight" :min="1" :max="1000" /> kg
          </el-form-item>
          <el-form-item label="上门时间">
            <el-date-picker v-model="orderForm.pickupTime" type="datetime" placeholder="选择时间" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="submitOrder">立即下单</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <!-- 附近回收点 -->
      <el-card class="nearby-stations">
        <h2>📍 附近回收点</h2>
        <el-table :data="stations" style="width: 100%">
          <el-table-column prop="name" label="名称" />
          <el-table-column prop="address" label="地址" />
          <el-table-column prop="distance" label="距离" />
          <el-table-column label="操作">
            <template #default>
              <el-button size="small">导航</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </el-main>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const orderForm = ref({
  type: '',
  weight: 5,
  pickupTime: ''
})

const stations = ref([
  { name: '如皋回收站 A', address: '如皋市 XX 路 XX 号', distance: '1.2km' },
  { name: '如皋回收站 B', address: '如皋市 YY 路 YY 号', distance: '2.5km' }
])

const submitOrder = () => {
  router.push('/login')
}
</script>

<style scoped>
.home {
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

.quick-order, .nearby-stations {
  margin-bottom: 20px;
  max-width: 1200px;
  margin-left: auto;
  margin-right: auto;
}
</style>
