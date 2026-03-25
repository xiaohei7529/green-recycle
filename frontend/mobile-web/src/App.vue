<template>
  <div id="app">
    <router-view />
    <van-tabbar v-if="showTabbar" route>
      <van-tabbar-item icon="home-o" to="/">首页</van-tabbar-item>
      <van-tabbar-item icon="orders-o" to="/orders">订单</van-tabbar-item>
      <van-tabbar-item icon="gold-coin-o" to="/prices">价格</van-tabbar-item>
      <van-tabbar-item icon="user-o" to="/profile">我的</van-tabbar-item>
    </van-tabbar>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

// 登录页不显示底部导航栏
const showTabbar = computed(() => route.name !== 'Login')
</script>

<style>
#app {
  font-family: -apple-system, BlinkMacSystemFont, 'Helvetica Neue', Helvetica,
    'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  padding-bottom: 50px;
}

body {
  margin: 0;
  background: #f5f5f5;
}
</style>
