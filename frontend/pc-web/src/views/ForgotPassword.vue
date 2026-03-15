<template>
  <div class="forgot-password-page">
    <NavBar />
    
    <section class="forgot-section">
      <div class="container">
        <div class="forgot-card">
          <div class="forgot-header">
            <h1>🔑 找回密码</h1>
            <p>通过手机短信验证重置密码</p>
          </div>

          <!-- 步骤指示器 -->
          <div class="steps">
            <div 
              class="step" 
              :class="{ active: currentStep >= 1, completed: currentStep > 1 }"
            >
              <div class="step-number">1</div>
              <div class="step-text">验证手机</div>
            </div>
            <div class="step-line" :class="{ active: currentStep > 1 }"></div>
            <div 
              class="step" 
              :class="{ active: currentStep >= 2, completed: currentStep > 2 }"
            >
              <div class="step-number">2</div>
              <div class="step-text">重置密码</div>
            </div>
            <div class="step-line" :class="{ active: currentStep > 2 }"></div>
            <div 
              class="step" 
              :class="{ active: currentStep >= 3 }"
            >
              <div class="step-number">3</div>
              <div class="step-text">完成</div>
            </div>
          </div>

          <!-- 步骤 1: 验证手机 -->
          <form v-if="currentStep === 1" @submit.prevent="sendCode" class="forgot-form">
            <div class="form-group">
              <label class="form-label">
                <span class="label-icon">📱</span>
                手机号
              </label>
              <input 
                v-model="form.phone" 
                type="tel" 
                placeholder="请输入注册手机号"
                maxlength="11"
                class="form-input"
                required
              />
            </div>

            <div class="form-group">
              <label class="form-label">
                <span class="label-icon">🔒</span>
                验证码
              </label>
              <div class="code-input-group">
                <input 
                  v-model="form.code" 
                  type="text" 
                  maxlength="6"
                  placeholder="6 位短信验证码"
                  class="form-input"
                  required
                />
                <button 
                  type="button" 
                  class="send-code-btn"
                  :disabled="countdown > 0"
                  @click="sendCode"
                >
                  {{ countdown > 0 ? `${countdown}s 后重发` : '获取验证码' }}
                </button>
              </div>
            </div>

            <CaptchaInput 
              v-model="form.captcha"
              @verified="captchaVerified = $event"
            />

            <button type="submit" class="btn-submit" :disabled="!canSubmitStep1">
              下一步
            </button>

            <div class="back-link">
              <router-link to="/login">返回登录</router-link>
            </div>
          </form>

          <!-- 步骤 2: 重置密码 -->
          <form v-if="currentStep === 2" @submit.prevent="resetPassword" class="forgot-form">
            <div class="success-tip">
              ✅ 手机验证通过
            </div>

            <div class="form-group">
              <label class="form-label">
                <span class="label-icon">🔒</span>
                新密码
              </label>
              <div class="password-input">
                <input 
                  v-model="form.newPassword" 
                  :type="showPassword ? 'text' : 'password'" 
                  placeholder="6-20 位字母和数字组合"
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
              <div class="password-strength" v-if="form.newPassword">
                <div class="strength-bars">
                  <div 
                    class="bar" 
                    :class="strengthLevel >= 1 ? 'weak' : ''"
                  ></div>
                  <div 
                    class="bar" 
                    :class="strengthLevel >= 2 ? 'medium' : ''"
                  ></div>
                  <div 
                    class="bar" 
                    :class="strengthLevel >= 3 ? 'strong' : ''"
                  ></div>
                </div>
                <span class="strength-text" :class="strengthClass">
                  {{ strengthText }}
                </span>
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">
                <span class="label-icon">🔒</span>
                确认密码
              </label>
              <input 
                v-model="form.confirmPassword" 
                type="password" 
                placeholder="请再次输入密码"
                class="form-input"
                required
              />
              <div class="error-message" v-if="passwordMismatch">
                两次输入的密码不一致
              </div>
            </div>

            <button type="submit" class="btn-submit" :disabled="!canSubmitStep2">
              确认重置
            </button>

            <button type="button" class="btn-back" @click="currentStep = 1">
              上一步
            </button>
          </form>

          <!-- 步骤 3: 完成 -->
          <div v-if="currentStep === 3" class="success-page">
            <div class="success-icon">✅</div>
            <h2>密码重置成功！</h2>
            <p>您的密码已更新，请使用新密码登录</p>
            <router-link to="/login" class="btn-login">
              去登录
            </router-link>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import CaptchaInput from '@/components/CaptchaInput.vue'

export default {
  name: 'ForgotPasswordPage',
  components: { NavBar, CaptchaInput },
  data() {
    return {
      currentStep: 1,
      showPassword: false,
      captchaVerified: false,
      countdown: 0,
      form: {
        phone: '',
        code: '',
        captcha: '',
        newPassword: '',
        confirmPassword: ''
      },
      countdownTimer: null
    }
  },
  computed: {
    canSubmitStep1() {
      return this.form.phone.length === 11 && 
             this.form.code.length === 6 && 
             this.captchaVerified
    },
    canSubmitStep2() {
      return this.form.newPassword.length >= 6 &&
             this.form.newPassword === this.form.confirmPassword
    },
    strengthLevel() {
      const pwd = this.form.newPassword
      if (!pwd) return 0
      if (pwd.length < 8) return 1
      if (/[a-zA-Z]/.test(pwd) && /[0-9]/.test(pwd)) return 2
      if (/[a-zA-Z]/.test(pwd) && /[0-9]/.test(pwd) && /[^a-zA-Z0-9]/.test(pwd)) return 3
      return 1
    },
    strengthClass() {
      return ['weak', 'medium', 'strong'][this.strengthLevel - 1] || ''
    },
    strengthText() {
      return ['弱', '中', '强'][this.strengthLevel - 1] || ''
    },
    passwordMismatch() {
      return this.form.confirmPassword && 
             this.form.newPassword !== this.form.confirmPassword
    }
  },
  methods: {
    sendCode() {
      if (this.countdown > 0) return
      
      // TODO: 调用 API 发送短信验证码
      console.log('发送验证码到:', this.form.phone)
      
      // 模拟发送成功
      this.countdown = 60
      this.countdownTimer = setInterval(() => {
        this.countdown--
        if (this.countdown <= 0) {
          clearInterval(this.countdownTimer)
        }
      }, 1000)
    },
    
    resetPassword() {
      if (!this.canSubmitStep2) return
      
      // TODO: 调用 API 重置密码
      console.log('重置密码:', {
        phone: this.form.phone,
        code: this.form.code,
        newPassword: this.form.newPassword
      })
      
      // 模拟成功
      this.currentStep = 3
    }
  },
  beforeUnmount() {
    if (this.countdownTimer) {
      clearInterval(this.countdownTimer)
    }
  }
}
</script>

<style scoped>
.forgot-password-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #ECFDF5 0%, #D1FAE5 100%);
  padding-top: 70px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

.forgot-section {
  padding: 3rem 0;
  display: flex;
  justify-content: center;
}

.forgot-card {
  max-width: 480px;
  width: 100%;
  background: white;
  border-radius: 20px;
  padding: 2.5rem;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
}

.forgot-header {
  text-align: center;
  margin-bottom: 2rem;
}

.forgot-header h1 {
  font-size: 2rem;
  font-weight: 800;
  color: #111827;
  margin-bottom: 0.5rem;
}

.forgot-header p {
  font-size: 1rem;
  color: #6B7280;
}

/* Steps */
.steps {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 2.5rem;
  padding: 0 1rem;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.step-number {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #F3F4F6;
  color: #9CA3AF;
  font-size: 1.25rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.step.active .step-number {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
}

.step.completed .step-number {
  background: #10B981;
  color: white;
}

.step.completed .step-number::after {
  content: '✓';
}

.step-text {
  font-size: 0.875rem;
  color: #6B7280;
  font-weight: 500;
}

.step.active .step-text {
  color: #10B981;
}

.step-line {
  flex: 1;
  height: 2px;
  background: #E5E7EB;
  margin: 0 0.5rem;
  margin-bottom: 1.5rem;
  transition: all 0.3s ease;
}

.step-line.active {
  background: #10B981;
}

/* Form */
.forgot-form {
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

.code-input-group {
  display: flex;
  gap: 12px;
}

.code-input-group input {
  flex: 1;
}

.send-code-btn {
  padding: 14px 20px;
  background: #10B981;
  color: white;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
}

.send-code-btn:hover:not(:disabled) {
  background: #059669;
  transform: translateY(-2px);
}

.send-code-btn:disabled {
  background: #D1D5DB;
  cursor: not-allowed;
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

.password-strength {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 8px;
}

.strength-bars {
  display: flex;
  gap: 4px;
  flex: 1;
}

.bar {
  flex: 1;
  height: 4px;
  background: #E5E7EB;
  border-radius: 2px;
  transition: all 0.3s ease;
}

.bar.weak {
  background: #EF4444;
}

.bar.medium {
  background: #F59E0B;
}

.bar.strong {
  background: #10B981;
}

.strength-text {
  font-size: 0.875rem;
  font-weight: 600;
  min-width: 40px;
}

.strength-text.weak {
  color: #EF4444;
}

.strength-text.medium {
  color: #F59E0B;
}

.strength-text.strong {
  color: #10B981;
}

.error-message {
  color: #EF4444;
  font-size: 0.875rem;
}

/* Buttons */
.btn-submit {
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

.btn-submit:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

.btn-submit:disabled {
  background: #D1D5DB;
  cursor: not-allowed;
  transform: none;
}

.btn-back {
  width: 100%;
  padding: 16px;
  background: #F9FAFB;
  color: #374151;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-back:hover {
  background: #F3F4F6;
}

.success-tip {
  background: #ECFDF5;
  color: #059669;
  padding: 12px 16px;
  border-radius: 12px;
  font-weight: 600;
  text-align: center;
  margin-bottom: 1rem;
}

.back-link {
  text-align: center;
  margin-top: 1rem;
}

.back-link a {
  color: #6B7280;
  text-decoration: none;
  font-size: 0.95rem;
}

.back-link a:hover {
  text-decoration: underline;
}

/* Success Page */
.success-page {
  text-align: center;
  padding: 2rem 0;
}

.success-icon {
  font-size: 5rem;
  margin-bottom: 1.5rem;
}

.success-page h2 {
  font-size: 1.75rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 0.75rem;
}

.success-page p {
  color: #6B7280;
  margin-bottom: 2rem;
}

.btn-login {
  display: inline-block;
  padding: 16px 40px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  border-radius: 12px;
  font-weight: 700;
  text-decoration: none;
  transition: all 0.3s;
  box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
}

.btn-login:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}
</style>
