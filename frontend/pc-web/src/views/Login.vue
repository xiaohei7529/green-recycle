<template>
  <div class="login-page">
    <!-- 导航栏 -->
    <NavBar />
    
    <!-- 登录卡片 -->
    <section class="login-section">
      <div class="container">
        <div class="login-card">
          <div class="login-header">
            <h1>🔐 用户登录</h1>
            <p>欢迎回来！请登录您的账号</p>
          </div>

          <form class="login-form" @submit.prevent="handleLogin">
            <!-- 手机号 -->
            <div class="form-group">
              <label class="form-label">
                <span class="label-icon">📱</span>
                手机号
              </label>
              <input 
                v-model="loginForm.phone" 
                type="tel" 
                placeholder="请输入手机号"
                maxlength="11"
                class="form-input"
                required
              />
            </div>

            <!-- 密码 -->
            <div class="form-group">
              <label class="form-label">
                <span class="label-icon">🔒</span>
                密码
              </label>
              <div class="password-input">
                <input 
                  v-model="loginForm.password" 
                  :type="showPassword ? 'text' : 'password'" 
                  placeholder="请输入密码"
                  class="form-input"
                  required
                />
                <button 
                  type="button" 
                  class="toggle-password"
                  @click="showPassword = !showPassword"
                >
                  {{ showPassword ? '🙈' : '👁️' }}
                </button>
              </div>
            </div>

            <!-- 记住我 & 忘记密码 -->
            <div class="form-options">
              <label class="checkbox-label">
                <input type="checkbox" v-model="loginForm.remember" />
                <span>记住我</span>
              </label>
              <router-link to="/forgot-password" class="forgot-link">
                忘记密码？
              </router-link>
            </div>

            <!-- 登录按钮 -->
            <button type="submit" class="btn-login">
              登录
            </button>

            <!-- 其他登录方式 -->
            <div class="divider">
              <span>其他登录方式</span>
            </div>

            <div class="social-login">
              <button type="button" class="btn-social" @click="wechatLogin">
                <span class="icon">💚</span>
                微信
              </button>
              <button type="button" class="btn-social" @click="alipayLogin">
                <span class="icon">💙</span>
                支付宝
              </button>
            </div>

            <!-- 注册链接 -->
            <div class="register-link">
              还没有账号？
              <router-link to="/register">立即注册</router-link>
            </div>
          </form>
        </div>

        <!-- 特性展示 -->
        <div class="features-showcase">
          <div class="feature-item">
            <div class="feature-icon">🚀</div>
            <div class="feature-text">快速下单</div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">💰</div>
            <div class="feature-text">价格透明</div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">🏆</div>
            <div class="feature-text">积分奖励</div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">♻️</div>
            <div class="feature-text">环保公益</div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'LoginPage',
  components: {
    NavBar
  },
  data() {
    return {
      showPassword: false,
      loginForm: {
        phone: '',
        password: '',
        remember: false
      }
    }
  },
  methods: {
    handleLogin() {
      console.log('登录:', this.loginForm)
      // TODO: 实现登录逻辑
      this.$router.push('/')
    },
    wechatLogin() {
      console.log('微信登录')
    },
    alipayLogin() {
      console.log('支付宝登录')
    }
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #ECFDF5 0%, #D1FAE5 100%);
  padding-top: 70px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

/* Login Section */
.login-section {
  padding: 3rem 0;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  gap: 3rem;
}

/* Login Card */
.login-card {
  flex: 1;
  max-width: 440px;
  background: white;
  border-radius: 20px;
  padding: 2.5rem;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
}

.login-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.login-header h1 {
  font-size: 2rem;
  font-weight: 800;
  color: #111827;
  margin-bottom: 0.5rem;
}

.login-header p {
  font-size: 1rem;
  color: #6B7280;
}

/* Form */
.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.95rem;
  font-weight: 600;
  color: #374151;
}

.label-icon {
  font-size: 1.1rem;
}

.form-input {
  width: 100%;
  padding: 14px 16px;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.2s;
  outline: none;
}

.form-input:focus {
  border-color: #10B981;
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
}

.form-input::placeholder {
  color: #9CA3AF;
}

.password-input {
  position: relative;
}

.toggle-password {
  position: absolute;
  right: 14px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.2rem;
  opacity: 0.6;
  transition: opacity 0.2s;
}

.toggle-password:hover {
  opacity: 1;
}

/* Form Options */
.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.9rem;
  color: #6B7280;
  cursor: pointer;
}

.checkbox-label input[type="checkbox"] {
  width: 16px;
  height: 16px;
  cursor: pointer;
}

.forgot-link {
  font-size: 0.9rem;
  color: #10B981;
  text-decoration: none;
  font-weight: 500;
}

.forgot-link:hover {
  text-decoration: underline;
}

/* Login Button */
.btn-login {
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

.btn-login:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

.btn-login:active {
  transform: translateY(0);
}

/* Divider */
.divider {
  position: relative;
  text-align: center;
  margin: 1rem 0;
}

.divider::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  height: 1px;
  background: #E5E7EB;
}

.divider span {
  position: relative;
  background: white;
  padding: 0 16px;
  font-size: 0.9rem;
  color: #9CA3AF;
}

/* Social Login */
.social-login {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.btn-social {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: #F9FAFB;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 0.95rem;
  font-weight: 500;
  color: #374151;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-social:hover {
  background: #F3F4F6;
  border-color: #D1D5DB;
}

.btn-social .icon {
  font-size: 1.2rem;
}

/* Register Link */
.register-link {
  text-align: center;
  font-size: 0.95rem;
  color: #6B7280;
}

.register-link a {
  color: #10B981;
  font-weight: 600;
  text-decoration: none;
}

.register-link a:hover {
  text-decoration: underline;
}

/* Features Showcase */
.features-showcase {
  flex: 1;
  max-width: 400px;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  padding-top: 2rem;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  padding: 1.5rem;
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.5);
}

.feature-icon {
  font-size: 2.5rem;
}

.feature-text {
  font-size: 1.1rem;
  font-weight: 600;
  color: #111827;
}

/* Responsive */
@media (max-width: 900px) {
  .login-section {
    flex-direction: column;
    align-items: center;
  }

  .features-showcase {
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
    max-width: 100%;
  }

  .feature-item {
    flex: 1;
    min-width: 150px;
  }
}

@media (max-width: 640px) {
  .login-card {
    padding: 2rem 1.5rem;
  }

  .features-showcase {
    display: none;
  }
}
</style>
