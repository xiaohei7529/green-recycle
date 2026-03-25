<template>
  <div class="profile">
    <van-nav-bar title="个人中心" />

    <!-- 用户信息卡片 -->
    <div class="user-header">
      <div class="avatar-wrap">
        <van-icon name="contact" size="48" color="#10B981" />
      </div>
      <div class="user-meta">
        <div class="user-name">{{ userInfo?.nickname || '未登录' }}</div>
        <div class="user-phone">{{ userInfo?.phone || '' }}</div>
      </div>
    </div>

    <!-- 数据统计 -->
    <van-grid :column-num="3" :border="false" class="stats-grid">
      <van-grid-item>
        <template #text>
          <div class="stat-value">{{ userInfo?.points || 0 }}</div>
          <div class="stat-label">积分</div>
        </template>
      </van-grid-item>
      <van-grid-item>
        <template #text>
          <div class="stat-value">-</div>
          <div class="stat-label">订单</div>
        </template>
      </van-grid-item>
      <van-grid-item>
        <template #text>
          <div class="stat-value">-</div>
          <div class="stat-label">收益</div>
        </template>
      </van-grid-item>
    </van-grid>

    <!-- 功能列表 -->
    <van-cell-group inset class="menu-group">
      <van-cell title="我的订单" is-link icon="orders-o" to="/orders" />
      <van-cell title="我的地址" is-link icon="location-o" @click="comingSoon" />
      <van-cell title="积分商城" is-link icon="gift-o" @click="comingSoon" />
      <van-cell title="客服中心" is-link icon="service-o" @click="comingSoon" />
      <van-cell title="设置" is-link icon="setting-o" @click="comingSoon" />
    </van-cell-group>

    <van-button type="danger" block plain class="logout-btn" @click="onLogout">
      退出登录
    </van-button>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { showConfirmDialog, showToast } from 'vant'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const userInfo = computed(() => authStore.userInfo)

const comingSoon = () => showToast('功能即将上线，敬请期待')

const onLogout = async () => {
  try {
    await showConfirmDialog({ title: '退出登录', message: '确定要退出登录吗？' })
    authStore.logout()
    showToast({ message: '已退出登录', type: 'success' })
    router.push('/login')
  } catch {
    // 用户取消
  }
}
</script>

<style scoped>
.profile {
  min-height: 100vh;
  background: #f5f5f5;
}

.user-header {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px 16px;
  background: white;
  margin-bottom: 12px;
}

.avatar-wrap {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background: #ECFDF5;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.user-name {
  font-size: 18px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 4px;
}

.user-phone {
  font-size: 13px;
  color: #9CA3AF;
}

.stats-grid {
  background: white;
  margin-bottom: 12px;
}

.stat-value {
  font-size: 20px;
  font-weight: 700;
  color: #10B981;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 12px;
  color: #9CA3AF;
}

.menu-group {
  margin-bottom: 20px;
}

.logout-btn {
  margin: 0 16px;
  --van-button-danger-color: #ee0a24;
  --van-button-danger-border-color: #ee0a24;
}
</style>
