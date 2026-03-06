<template>
  <div class="login">
    <div class="logo">♻️</div>
    <h1 class="title">Green Recycle</h1>
    <p class="subtitle">让回收更简单</p>

    <van-form @submit="onSubmit">
      <van-cell-group inset>
        <van-field
          v-model="phone"
          name="phone"
          placeholder="请输入手机号"
          :rules="[{ pattern: /^1\d{10}$/, message: '请输入正确的手机号' }]"
        />
        <van-field
          v-model="code"
          name="code"
          type="digit"
          placeholder="请输入验证码"
          maxlength="6"
          :rules="[{ required: true, message: '请输入验证码' }]"
        >
          <template #button>
            <van-button size="small" type="primary" @click="sendCode">
              获取验证码
            </van-button>
          </template>
        </van-field>
      </van-cell-group>

      <div class="actions">
        <van-button round block type="primary" native-type="submit" class="submit-btn">
          登录/注册
        </van-button>

        <van-divider>其他登录方式</van-divider>

        <van-button round block type="success" class="wechat-btn" @click="wechatLogin">
          💬 微信一键登录
        </van-button>
      </div>
    </van-form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { VanForm, VanCellGroup, VanField, VanButton, VanDivider, showToast } from 'vant'

const router = useRouter()
const phone = ref('')
const code = ref('')

const sendCode = () => {
  if (phone.value.length !== 11) {
    showToast('请输入正确的手机号')
    return
  }
  showToast('验证码已发送')
}

const onSubmit = () => {
  if (!phone.value || !code.value) {
    showToast('请填写完整信息')
    return
  }
  showToast('登录成功')
  setTimeout(() => {
    router.push('/')
  }, 1000)
}

const wechatLogin = () => {
  showToast('微信登录功能开发中')
}
</script>

<style scoped>
.login {
  padding: 60px 20px;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.logo {
  font-size: 100px;
  text-align: center;
  margin-bottom: 20px;
}

.title {
  color: white;
  text-align: center;
  font-size: 32px;
  margin-bottom: 10px;
}

.subtitle {
  color: rgba(255, 255, 255, 0.8);
  text-align: center;
  font-size: 16px;
  margin-bottom: 60px;
}

.actions {
  margin-top: 40px;
  padding: 0 20px;
}

.submit-btn {
  background: linear-gradient(135deg, #667eea, #764ba2);
}

.wechat-btn {
  background: #07C160;
}
</style>
