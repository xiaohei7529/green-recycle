<template>
  <el-container class="layout">
    <el-aside width="200px">
      <div class="logo">♻️ Green Recycle</div>
      <el-menu :default-active="activeMenu" router background-color="#304156" text-color="#bfcbd9" active-text-color="#409EFF">
        <el-menu-item index="/dashboard">📊 数据看板</el-menu-item>
        <el-menu-item index="/users">👥 用户管理</el-menu-item>
        <el-menu-item index="/recyclers">🚚 回收员管理</el-menu-item>
        <el-menu-item index="/orders">📦 订单管理</el-menu-item>
        <el-menu-item index="/prices">💰 价格管理</el-menu-item>
        <el-menu-item index="/reports">📈 报表分析</el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header>
        <div class="header-content">
          <span>管理后台</span>
          <el-dropdown>
            <span class="user-info">管理员 ▼</span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item>个人设置</el-dropdown-item>
                <el-dropdown-item divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref } from 'vue'
const activeMenu = ref('/dashboard')
</script>

<style>
.layout {
  height: 100vh;
}

.el-aside {
  background: #304156;
  color: white;
}

.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  font-size: 20px;
  font-weight: bold;
  background: #2b3a4b;
}

.el-header {
  background: white;
  border-bottom: 1px solid #e6e6e6;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
}

.user-info {
  cursor: pointer;
}
</style>
