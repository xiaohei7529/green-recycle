<template>
  <div class="login">
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
      <el-card class="login-card">
        <h2>🔐 用户登录</h2>
        <el-form :model="loginForm" label-width="80px">
          <el-form-item label="手机号">
            <el-input v-model="loginForm.phone" placeholder="请输入手机号" maxlength="11" />
          </el-form-item>
          <el-form-item label="密码">
            <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" style="width: 100%" @click="handleLogin">登录</el-button>
          </el-form-item>
          <el-form-item>
            <div style="text-align: center">
              <el-link type="primary">忘记密码</el-link>
              <el-link type="primary" style="margin-left: 20px">立即注册</el-link>
            </div>
          </el-form-item>
          <el-divider>其他登录方式</el-divider>
          <el-form-item>
            <div style="text-align: center">
              <el-button icon="Wechat" circle />
              <el-button icon="Alipay" circle />
            </div>
          </el-form-item>
        </el-form>
      </el-card>
    </el-main>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const loginForm = ref({
  phone: '',
  password: ''
})

const handleLogin = () => {
  console.log('登录:', loginForm.value)
  router.push('/')
}
</script>

<style scoped>
.login {
  min-height: 100vh;
  background: #f5f7fa;
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

.login-card {
  max-width: 400px;
  margin: 50px auto;
}

.login h2 {
  text-align: center;
  margin-bottom: 30px;
}
</style>
