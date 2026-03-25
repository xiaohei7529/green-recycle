<template>
  <div class="login">
    <div class="logo">♻️</div>
    <h1 class="title">Green Recycle</h1>
    <p class="subtitle">让回收更简单，让环境更美好</p>

    <van-form @submit="onSubmit">
      <van-cell-group inset>
        <van-field
          v-model="phone"
          name="phone"
          label="手机号"
          placeholder="请输入手机号"
          :rules="[{ pattern: /^1\d{10}$/, message: '请输入正确的手机号' }]"
        />
        <van-field
          v-model="password"
          type="password"
          name="password"
          label="密码"
          placeholder="请输入密码"
          :rules="[{ required: true, message: '请输入密码' }]"
        />
      </van-cell-group>

      <div class="actions">
        <van-button
          round
          block
          type="primary"
          native-type="submit"
          :loading="loading"
          loading-text="登录中..."
          class="submit-btn"
        >
          登录
        </van-button>

        <van-divider>其他方式</van-divider>

        <van-button round block plain type="primary" class="wechat-btn" @click="wechatLogin">
          💬 微信一键登录
        </van-button>

        <div class="register-tip">
          还没有账号？密码登录首次自动注册
        </div>
      </div>
    </van-form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { showToast, showFailToast } from 'vant'
import { loginUser } from '@/api/auth'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const phone = ref('')
const password = ref('')
const loading = ref(false)

const onSubmit = async () => {
  loading.value = true
  try {
    const res = await loginUser(phone.value, password.value)
    authStore.setAuth(res.data.token, null)
    showToast({ message: '登录成功', type: 'success' })
    const redirect = route.query.redirect || '/'
    router.push(redirect)
  } catch (err) {
    showFailToast(err.message || '登录失败')
  } finally {
    loading.value = false
  }
}

const wechatLogin = () => {
  showToast('微信登录功能即将上线')
}
</script>

<style scoped>
.login {
  padding: 60px 20px 40px;
  min-height: 100vh;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
}

.logo {
  font-size: 80px;
  text-align: center;
  margin-bottom: 16px;
}

.title {
  color: white;
  text-align: center;
  font-size: 28px;
  font-weight: 700;
  margin-bottom: 8px;
}

.subtitle {
  color: rgba(255, 255, 255, 0.85);
  text-align: center;
  font-size: 14px;
  margin-bottom: 48px;
}

.actions {
  margin-top: 32px;
  padding: 0 4px;
}

.submit-btn {
  --van-button-primary-background: #059669;
  --van-button-primary-border-color: #059669;
  font-size: 16px;
  height: 48px;
}

.wechat-btn {
  --van-button-primary-color: #10B981;
  --van-button-primary-border-color: #10B981;
  height: 44px;
}

.register-tip {
  text-align: center;
  color: rgba(255, 255, 255, 0.75);
  font-size: 13px;
  margin-top: 20px;
}

:deep(.van-cell-group--inset) {
  border-radius: 12px;
  overflow: hidden;
}
</style>
