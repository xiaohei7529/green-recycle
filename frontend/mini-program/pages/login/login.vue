<template>
  <view class="container">
    <view class="logo">♻️</view>
    <view class="title">Green Recycle</view>
    <view class="subtitle">让回收更简单</view>

    <view class="form">
      <input class="input" v-model="phone" type="number" maxlength="11" placeholder="请输入手机号" />
      <input class="input" v-model="code" type="number" maxlength="6" placeholder="请输入验证码" />
      <button class="btn-code" @click="sendCode">获取验证码</button>
      
      <button class="btn-login" @click="login">登录/注册</button>
      
      <view class="divider">其他登录方式</view>
      
      <button class="btn-wechat" @click="wechatLogin">
        <text class="wechat-icon">💬</text>
        <text>微信一键登录</text>
      </button>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'

const phone = ref('')
const code = ref('')

const sendCode = () => {
  if (phone.value.length !== 11) {
    uni.showToast({ title: '请输入正确的手机号', icon: 'none' })
    return
  }
  uni.showToast({ title: '验证码已发送', icon: 'success' })
}

const login = () => {
  if (!phone.value || !code.value) {
    uni.showToast({ title: '请填写完整信息', icon: 'none' })
    return
  }
  uni.showToast({ title: '登录成功', icon: 'success' })
  setTimeout(() => {
    uni.switchTab({ url: '/pages/index/index' })
  }, 1000)
}

const wechatLogin = () => {
  uni.getUserProfile({
    desc: '用于完善用户资料',
    success: (res) => {
      console.log('获取用户信息:', res.userInfo)
      uni.showToast({ title: '微信登录成功', icon: 'success' })
      setTimeout(() => {
        uni.switchTab({ url: '/pages/index/index' })
      }, 1000)
    }
  })
}
</script>

<style scoped>
.container {
  padding: 60rpx 40rpx;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.logo {
  font-size: 120rpx;
  text-align: center;
  margin-bottom: 20rpx;
}

.title {
  font-size: 48rpx;
  color: white;
  text-align: center;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.subtitle {
  font-size: 28rpx;
  color: rgba(255,255,255,0.8);
  text-align: center;
  margin-bottom: 80rpx;
}

.form {
  background: white;
  border-radius: 20rpx;
  padding: 40rpx;
}

.input {
  background: #f5f7fa;
  border-radius: 10rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
  font-size: 28rpx;
}

.btn-code {
  background: #409EFF;
  color: white;
  border-radius: 10rpx;
  padding: 20rpx;
  font-size: 28rpx;
  margin-bottom: 40rpx;
}

.btn-login {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border-radius: 50rpx;
  padding: 30rpx;
  font-size: 32rpx;
  margin-bottom: 40rpx;
}

.divider {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  margin-bottom: 30rpx;
  position: relative;
}

.divider::before,
.divider::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 30%;
  height: 1rpx;
  background: #eee;
}

.divider::before { left: 0; }
.divider::after { right: 0; }

.btn-wechat {
  background: #07C160;
  color: white;
  border-radius: 50rpx;
  padding: 30rpx;
  font-size: 32rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.wechat-icon {
  margin-right: 10rpx;
  font-size: 36rpx;
}
</style>
