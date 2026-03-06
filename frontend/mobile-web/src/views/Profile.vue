<template>
  <div class="profile">
    <!-- 用户信息 -->
    <van-card
      class="user-card"
      :thumb="userInfo.avatar"
      title="用户昵称"
      desc="138****8000"
    >
      <template #num>
        <div class="user-stats">
          <div class="stat-item">
            <div class="stat-value">1250</div>
            <div class="stat-label">积分</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">15</div>
            <div class="stat-label">订单</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">¥358.50</div>
            <div class="stat-label">收益</div>
          </div>
        </div>
      </template>
    </van-card>

    <!-- 功能列表 -->
    <van-cell-group inset class="menu-group">
      <van-cell title="我的订单" is-link icon="orders-o" to="/orders" />
      <van-cell title="我的地址" is-link icon="location-o" />
      <van-cell title="积分商城" is-link icon="gift-o" />
      <van-cell title="客服中心" is-link icon="service-o" />
      <van-cell title="设置" is-link icon="setting-o" />
    </van-cell-group>

    <van-button type="danger" block class="logout-btn" @click="logout">
      退出登录
    </van-button>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { VanCard, VanCellGroup, VanCell, VanButton, showToast } from 'vant'

const userInfo = ref({
  avatar: 'https://via.placeholder.com/100x100/409EFF/ffffff?text=User'
})

const logout = () => {
  showToast('已退出登录')
  // TODO: 执行退出逻辑
}
</script>

<style scoped>
.profile {
  padding: 10px 0;
  background: #f5f5f5;
  min-height: 100vh;
}

.user-card {
  margin-bottom: 10px;
}

.user-stats {
  display: flex;
  justify-content: space-around;
  padding: 20px 0;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 12px;
  color: #999;
}

.menu-group {
  margin-bottom: 20px;
}

.logout-btn {
  margin: 0 10px;
}
</style>
