<template>
  <div class="home">
    <!-- 顶部 Banner -->
    <van-image src="https://via.placeholder.com/750x300/67C23A/ffffff?text=Green+Recycle" class="banner" />

    <!-- 快速下单 -->
    <van-card
      class="quick-order"
      title="🚀 快速下单"
      desc="一键预约，上门回收"
      @click="goToCreateOrder"
    />

    <!-- 功能网格 -->
    <van-grid :column-num="4" :border="false" class="grid">
      <van-grid-item icon="orders-o" text="我的订单" to="/orders" />
      <van-grid-item icon="gold-coin-o" text="回收价格" to="/prices" />
      <van-grid-item icon="location-o" text="附近回收点" />
      <van-grid-item icon="gift-o" text="积分商城" />
    </van-grid>

    <!-- 公告 -->
    <van-notice-bar
      left-icon="volume-o"
      text="回收价格每日更新，欢迎下单！新人首单立减 5 元！"
      class="notice"
    />

    <!-- 热门活动 -->
    <van-card
      title="🎉 新人专享"
      desc="首单立减 5 元，邀请好友得 10 元"
      class="activity"
    />
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { VanImage, VanCard, VanGrid, VanGridItem, VanNoticeBar } from 'vant'

const router = useRouter()

const goToCreateOrder = () => {
  router.push('/order/create')
}
</script>

<style scoped>
.home {
  padding: 0 0 20px 0;
}

.banner {
  width: 100%;
  height: 300px;
}

.quick-order {
  margin: 10px;
}

.grid {
  margin: 20px 0;
  background: white;
}

.notice {
  margin: 10px;
}

.activity {
  margin: 10px;
}
</style>
