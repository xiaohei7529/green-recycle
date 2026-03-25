<template>
  <div class="home">
    <!-- Banner -->
    <div class="banner">
      <div class="banner-content">
        <div class="banner-icon">♻️</div>
        <h2 class="banner-title">绿色回收</h2>
        <p class="banner-subtitle">让废品变成价值，让环境更美好</p>
        <van-button
          round
          type="primary"
          size="small"
          class="banner-btn"
          @click="goToCreateOrder"
        >
          立即下单
        </van-button>
      </div>
    </div>

    <!-- 快速入口网格 -->
    <van-grid :column-num="4" :border="false" class="grid">
      <van-grid-item icon="orders-o" text="我的订单" to="/orders" />
      <van-grid-item icon="gold-coin-o" text="回收价格" to="/prices" />
      <van-grid-item icon="location-o" text="附近回收点" @click="comingSoon" />
      <van-grid-item icon="gift-o" text="积分商城" @click="comingSoon" />
    </van-grid>

    <!-- 公告 -->
    <van-notice-bar
      left-icon="volume-o"
      :scrollable="true"
      text="回收价格每日更新，欢迎下单！新人首单立减 5 元！"
      class="notice"
    />

    <!-- 活动卡片 -->
    <van-cell-group inset class="activity-group">
      <van-cell
        title="🎉 新人专享"
        label="首单立减 5 元，邀请好友再得 10 元"
        is-link
        @click="comingSoon"
      />
      <van-cell
        title="♻️ 今日回收"
        label="废纸 ¥1.5/kg · 塑料 ¥2.0/kg · 金属 ¥3.5/kg"
        is-link
        to="/prices"
      />
    </van-cell-group>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { showToast } from 'vant'

const router = useRouter()

const goToCreateOrder = () => router.push('/order/create')
const comingSoon = () => showToast('功能即将上线，敬请期待')
</script>

<style scoped>
.home {
  padding-bottom: 20px;
  background: #f5f5f5;
  min-height: 100vh;
}

.banner {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  padding: 40px 24px 32px;
  text-align: center;
  position: relative;
  overflow: hidden;
}

.banner::before {
  content: '';
  position: absolute;
  top: -40%;
  right: -20%;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.08);
}

.banner-icon {
  font-size: 56px;
  margin-bottom: 8px;
}

.banner-title {
  color: white;
  font-size: 24px;
  font-weight: 700;
  margin: 0 0 8px;
}

.banner-subtitle {
  color: rgba(255, 255, 255, 0.85);
  font-size: 13px;
  margin: 0 0 20px;
}

.banner-btn {
  --van-button-primary-background: white;
  --van-button-primary-border-color: white;
  --van-button-primary-color: #10B981;
  font-weight: 600;
}

.grid {
  margin: 12px 0;
  background: white;
}

.notice {
  margin: 0 12px 12px;
  border-radius: 8px;
  overflow: hidden;
}

.activity-group {
  margin-bottom: 12px;
}
</style>
