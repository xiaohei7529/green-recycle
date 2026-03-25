<template>
  <div class="register-page">
    <section class="register-section">
      <div class="container">
        <div class="register-card">
          <div class="register-header">
            <h1>🌱 创建账号</h1>
            <p>加入绿色回收，让环保更有价值</p>
          </div>

          <form class="register-form" @submit.prevent="handleRegister">
            <div class="form-group">
              <label class="form-label">📱 手机号</label>
              <input
                v-model="form.phone"
                type="tel"
                placeholder="请输入手机号"
                maxlength="11"
                class="form-input"
                required
              />
            </div>

            <div class="form-group">
              <label class="form-label">📩 验证码</label>
              <div class="code-input">
                <input
                  v-model="form.code"
                  type="text"
                  placeholder="请输入验证码"
                  maxlength="6"
                  class="form-input"
                  required
                />
                <button
                  type="button"
                  class="btn-send-code"
                  :disabled="countdown > 0"
                  @click="sendCode"
                >
                  {{ countdown > 0 ? `${countdown}s 后重发` : '获取验证码' }}
                </button>
              </div>
              <p class="field-tip">短信验证码功能即将上线，当前可填写任意 6 位数字</p>
            </div>

            <div class="form-group">
              <label class="form-label">🔒 密码</label>
              <input
                v-model="form.password"
                type="password"
                placeholder="请设置密码（至少 6 位）"
                minlength="6"
                class="form-input"
                required
              />
            </div>

            <div class="form-group">
              <label class="form-label">🔒 确认密码</label>
              <input
                v-model="form.confirmPassword"
                type="password"
                placeholder="请再次输入密码"
                class="form-input"
                required
              />
            </div>

            <div v-if="errorMsg" class="error-msg">{{ errorMsg }}</div>
            <div v-if="successMsg" class="success-msg">{{ successMsg }}</div>

            <button type="submit" class="btn-register" :disabled="loading">
              {{ loading ? '注册中...' : '立即注册' }}
            </button>

            <div class="login-link">
              已有账号？
              <router-link to="/login">立即登录</router-link>
            </div>
          </form>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import { registerUser } from '@/api/auth'

export default {
  name: 'RegisterPage',
  data() {
    return {
      loading: false,
      countdown: 0,
      errorMsg: '',
      successMsg: '',
      form: {
        phone: '',
        code: '',
        password: '',
        confirmPassword: ''
      }
    }
  },
  methods: {
    sendCode() {
      if (!this.form.phone || this.form.phone.length !== 11) {
        this.errorMsg = '请先填写正确的手机号'
        return
      }
      this.errorMsg = ''
      this.countdown = 60
      const timer = setInterval(() => {
        this.countdown--
        if (this.countdown <= 0) clearInterval(timer)
      }, 1000)
    },
    async handleRegister() {
      this.errorMsg = ''
      this.successMsg = ''

      if (this.form.password !== this.form.confirmPassword) {
        this.errorMsg = '两次输入的密码不一致'
        return
      }
      if (this.form.password.length < 6) {
        this.errorMsg = '密码长度不能少于 6 位'
        return
      }

      this.loading = true
      try {
        await registerUser(this.form.phone, this.form.code, this.form.password)
        this.successMsg = '注册成功！正在跳转到登录页...'
        setTimeout(() => this.$router.push('/login'), 1500)
      } catch (err) {
        this.errorMsg = err.message
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.register-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #ECFDF5 0%, #D1FAE5 100%);
  display: flex;
  justify-content: center;
  align-items: center;
}

.container {
  max-width: 500px;
  margin: 0 auto;
  padding: 2rem 24px;
  width: 100%;
}

.register-card {
  background: white;
  border-radius: 20px;
  padding: 2.5rem;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
}

.register-header {
  text-align: center;
  margin-bottom: 2rem;
}

.register-header h1 {
  font-size: 2rem;
  font-weight: 800;
  color: #111827;
  margin-bottom: 0.5rem;
}

.register-header p {
  font-size: 1rem;
  color: #6B7280;
}

.register-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-label {
  font-size: 0.95rem;
  font-weight: 600;
  color: #374151;
}

.form-input {
  width: 100%;
  padding: 14px 16px;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.2s;
  outline: none;
  box-sizing: border-box;
}

.form-input:focus {
  border-color: #10B981;
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
}

.code-input {
  display: flex;
  gap: 12px;
}

.btn-send-code {
  white-space: nowrap;
  padding: 0 20px;
  background: #ECFDF5;
  color: #10B981;
  border: 2px solid #10B981;
  border-radius: 12px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-send-code:hover:not(:disabled) {
  background: #10B981;
  color: white;
}

.btn-send-code:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.field-tip {
  font-size: 0.8rem;
  color: #9CA3AF;
}

.error-msg {
  padding: 12px 16px;
  background: #FEF2F2;
  border: 1px solid #FECACA;
  border-radius: 10px;
  color: #DC2626;
  font-size: 0.9rem;
}

.success-msg {
  padding: 12px 16px;
  background: #ECFDF5;
  border: 1px solid #6EE7B7;
  border-radius: 10px;
  color: #065F46;
  font-size: 0.9rem;
}

.btn-register {
  width: 100%;
  padding: 16px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
}

.btn-register:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

.btn-register:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.login-link {
  text-align: center;
  font-size: 0.95rem;
  color: #6B7280;
}

.login-link a {
  color: #10B981;
  font-weight: 600;
  text-decoration: none;
}

.login-link a:hover {
  text-decoration: underline;
}
</style>
