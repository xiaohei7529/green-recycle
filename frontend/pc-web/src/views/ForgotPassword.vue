<template>
  <div class="forgot-page">
    <section class="forgot-section">
      <div class="container">
        <div class="forgot-card">
          <div class="forgot-header">
            <h1>🔑 找回密码</h1>
            <p>通过手机号验证码重置密码</p>
          </div>
          <div class="coming-soon">
            <div class="icon">🚧</div>
            <p>该功能正在开发中，敬请期待</p>
            <router-link to="/login" class="btn-back">返回登录</router-link>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
export default { name: 'ForgotPasswordPage' }
</script>

<style scoped>
.forgot-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #ECFDF5 0%, #D1FAE5 100%);
  display: flex;
  align-items: center;
}
.container { max-width: 440px; margin: 0 auto; padding: 2rem 24px; }
.forgot-card {
  background: white;
  border-radius: 20px;
  padding: 2.5rem;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  text-align: center;
}
.forgot-header { margin-bottom: 2rem; }
.forgot-header h1 { font-size: 2rem; font-weight: 800; color: #111827; margin-bottom: 0.5rem; }
.forgot-header p { color: #6B7280; }
.coming-soon .icon { font-size: 4rem; margin-bottom: 1rem; }
.coming-soon p { color: #6B7280; margin-bottom: 1.5rem; }
.btn-back {
  display: inline-block;
  padding: 12px 32px;
  background: #10B981;
  color: white;
  border-radius: 12px;
  text-decoration: none;
  font-weight: 600;
}
</style>
