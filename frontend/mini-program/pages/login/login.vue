<template>
  <view class="container">
    <view class="top-area">
      <view class="logo">♻️</view>
      <view class="title">Green Recycle</view>
      <view class="subtitle">让回收更简单，让地球更美好</view>
    </view>

    <view class="form-card">
      <!-- Tab 切换 -->
      <view class="form-tabs">
        <view
          :class="['form-tab', activeForm === 'login' ? 'active' : '']"
          @click="activeForm = 'login'"
        >登录</view>
        <view
          :class="['form-tab', activeForm === 'register' ? 'active' : '']"
          @click="activeForm = 'register'"
        >注册</view>
      </view>

      <!-- 登录表单 -->
      <view v-if="activeForm === 'login'">
        <view class="input-group">
          <text class="input-label">手机号</text>
          <input
            class="input"
            v-model="phone"
            type="number"
            maxlength="11"
            placeholder="请输入手机号"
          />
        </view>
        <view class="input-group">
          <text class="input-label">密码</text>
          <input
            class="input"
            v-model="password"
            password
            placeholder="请输入密码"
          />
        </view>
        <button class="btn-primary" :disabled="loading" @click="handleLogin">
          {{ loading ? '登录中...' : '立即登录' }}
        </button>
      </view>

      <!-- 注册表单 -->
      <view v-else>
        <view class="input-group">
          <text class="input-label">手机号</text>
          <input
            class="input"
            v-model="phone"
            type="number"
            maxlength="11"
            placeholder="请输入手机号"
          />
        </view>
        <view class="input-group">
          <text class="input-label">验证码</text>
          <view class="code-row">
            <input
              class="input code-input"
              v-model="code"
              type="number"
              maxlength="6"
              placeholder="请输入验证码"
            />
            <button
              class="btn-code"
              :disabled="codeCooldown > 0"
              @click="sendCode"
            >
              {{ codeCooldown > 0 ? `${codeCooldown}s` : '获取验证码' }}
            </button>
          </view>
        </view>
        <view class="input-group">
          <text class="input-label">密码</text>
          <input
            class="input"
            v-model="password"
            password
            placeholder="请设置密码（6位以上）"
          />
        </view>
        <button class="btn-primary" :disabled="loading" @click="handleRegister">
          {{ loading ? '注册中...' : '立即注册' }}
        </button>
      </view>

      <!-- 微信一键登录 -->
      <view class="divider"><text>其他方式</text></view>
      <button class="btn-wechat" @click="wechatLogin">
        <text class="wechat-icon">💬</text>
        <text>微信一键登录</text>
      </button>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { loginUser, registerUser } from '@/api/auth'

const authStore = useAuthStore()

const activeForm = ref('login')
const phone = ref('')
const password = ref('')
const code = ref('')
const loading = ref(false)
const codeCooldown = ref(0)

const validatePhone = () => {
  if (!/^1[3-9]\d{9}$/.test(phone.value)) {
    uni.showToast({ title: '请输入正确的手机号', icon: 'none' })
    return false
  }
  return true
}

const sendCode = () => {
  if (!validatePhone()) return
  uni.showToast({ title: '验证码已发送（模拟）', icon: 'success' })
  codeCooldown.value = 60
  const timer = setInterval(() => {
    codeCooldown.value--
    if (codeCooldown.value <= 0) clearInterval(timer)
  }, 1000)
}

const handleLogin = async () => {
  if (!validatePhone()) return
  if (!password.value) {
    uni.showToast({ title: '请输入密码', icon: 'none' })
    return
  }
  loading.value = true
  try {
    const res = await loginUser(phone.value, password.value)
    authStore.setAuth(res.token, res.user)
    uni.showToast({ title: '登录成功', icon: 'success' })
    setTimeout(() => {
      uni.switchTab({ url: '/pages/index/index' })
    }, 800)
  } catch (err) {
    // request.js 内部已经 showToast，这里无需重复提示
  } finally {
    loading.value = false
  }
}

const handleRegister = async () => {
  if (!validatePhone()) return
  if (!code.value) {
    uni.showToast({ title: '请输入验证码', icon: 'none' })
    return
  }
  if (password.value.length < 6) {
    uni.showToast({ title: '密码至少 6 位', icon: 'none' })
    return
  }
  loading.value = true
  try {
    const res = await registerUser(phone.value, code.value, password.value)
    authStore.setAuth(res.token, res.user)
    uni.showToast({ title: '注册成功', icon: 'success' })
    setTimeout(() => {
      uni.switchTab({ url: '/pages/index/index' })
    }, 800)
  } catch (err) {
    // 错误已在 request.js 内展示
  } finally {
    loading.value = false
  }
}

const wechatLogin = () => {
  uni.showToast({ title: '微信登录功能即将上线', icon: 'none' })
}
</script>

<style scoped>
.container {
  min-height: 100vh;
  background: linear-gradient(160deg, #10B981 0%, #059669 50%, #065f46 100%);
  padding: 0 40rpx 60rpx;
}

.top-area {
  padding: 120rpx 0 80rpx;
  text-align: center;
}

.logo {
  font-size: 120rpx;
  margin-bottom: 20rpx;
}

.title {
  font-size: 52rpx;
  color: #fff;
  font-weight: bold;
  margin-bottom: 16rpx;
}

.subtitle {
  font-size: 28rpx;
  color: rgba(255, 255, 255, 0.85);
}

.form-card {
  background: #fff;
  border-radius: 24rpx;
  padding: 40rpx;
  box-shadow: 0 8rpx 40rpx rgba(0, 0, 0, 0.15);
}

.form-tabs {
  display: flex;
  margin-bottom: 40rpx;
  border-bottom: 2rpx solid #eee;
}

.form-tab {
  flex: 1;
  text-align: center;
  padding: 24rpx 0;
  font-size: 32rpx;
  color: #999;
  position: relative;
}

.form-tab.active {
  color: #10B981;
  font-weight: bold;
}

.form-tab.active::after {
  content: '';
  position: absolute;
  bottom: -2rpx;
  left: 20%;
  width: 60%;
  height: 4rpx;
  background: #10B981;
  border-radius: 2rpx;
}

.input-group {
  margin-bottom: 28rpx;
}

.input-label {
  display: block;
  font-size: 26rpx;
  color: #666;
  margin-bottom: 12rpx;
}

.input {
  width: 100%;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 28rpx 24rpx;
  font-size: 30rpx;
  box-sizing: border-box;
}

.code-row {
  display: flex;
  gap: 20rpx;
  align-items: center;
}

.code-input {
  flex: 1;
}

.btn-code {
  flex-shrink: 0;
  background: #10B981;
  color: #fff;
  font-size: 24rpx;
  padding: 0 24rpx;
  height: 88rpx;
  line-height: 88rpx;
  border-radius: 12rpx;
  white-space: nowrap;
}

.btn-code[disabled] {
  background: #a7f3d0;
  color: #fff;
}

.btn-primary {
  width: 100%;
  background: linear-gradient(90deg, #10B981, #059669);
  color: #fff;
  border-radius: 50rpx;
  padding: 32rpx 0;
  font-size: 34rpx;
  font-weight: bold;
  margin-top: 16rpx;
  text-align: center;
}

.btn-primary[disabled] {
  opacity: 0.6;
}

.divider {
  text-align: center;
  color: #ccc;
  font-size: 26rpx;
  margin: 40rpx 0 30rpx;
  position: relative;
}

.divider::before,
.divider::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 32%;
  height: 1rpx;
  background: #eee;
}

.divider::before { left: 0; }
.divider::after { right: 0; }

.btn-wechat {
  width: 100%;
  background: #07C160;
  color: #fff;
  border-radius: 50rpx;
  padding: 30rpx 0;
  font-size: 32rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12rpx;
}

.wechat-icon {
  font-size: 36rpx;
}
</style>
