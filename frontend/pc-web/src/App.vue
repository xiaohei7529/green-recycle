<template>
  <div id="app">
    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="container">
        <div class="logo">
          <span class="logo-icon">♻️</span>
          <span class="logo-text">Green Recycle</span>
        </div>
        <nav class="nav">
          <router-link to="/" class="nav-item">首页</router-link>
          <router-link to="/prices" class="nav-item">回收价格</router-link>
          <router-link to="/orders" class="nav-item">我的订单</router-link>
          <router-link to="/profile" class="nav-item">个人中心</router-link>
        </nav>
        <div class="user-actions">
          <router-link v-if="!isLoggedIn" to="/login" class="btn-login">登录</router-link>
          <button v-else @click="logout" class="btn-logout">退出</button>
        </div>
      </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-content">
      <router-view />
    </main>

    <!-- 底部 -->
    <footer class="footer">
      <div class="container">
        <div class="footer-links">
          <div class="footer-section">
            <h4>关于我们</h4>
            <a href="#">公司简介</a>
            <a href="#">联系我们</a>
            <a href="#">加入我们</a>
          </div>
          <div class="footer-section">
            <h4>用户服务</h4>
            <a href="#">帮助中心</a>
            <a href="#">回收指南</a>
            <a href="#">常见问题</a>
          </div>
          <div class="footer-section">
            <h4>合作伙伴</h4>
            <a href="#">回收站点</a>
            <a href="#">企业回收</a>
            <a href="#">政府合作</a>
          </div>
          <div class="footer-section">
            <h4>关注我们</h4>
            <div class="social-links">
              <a href="#" class="social-icon">微信</a>
              <a href="#" class="social-icon">微博</a>
              <a href="#" class="social-icon">抖音</a>
            </div>
          </div>
        </div>
        <div class="footer-bottom">
          <p>&copy; 2026 Green Recycle. All rights reserved.</p>
          <p>让回收更简单，让环境更美好</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'App',
  computed: {
    isLoggedIn() {
      return !!localStorage.getItem('userToken')
    }
  },
  methods: {
    logout() {
      localStorage.removeItem('userToken')
      localStorage.removeItem('userInfo')
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* 顶部导航栏 */
.header {
  background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
  color: white;
  padding: 1rem 0;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header .container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.logo {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.5rem;
  font-weight: bold;
}

.logo-icon {
  font-size: 2rem;
}

.nav {
  display: flex;
  gap: 2rem;
}

.nav-item {
  color: white;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  transition: all 0.3s;
}

.nav-item:hover,
.nav-item.router-link-active {
  background: rgba(255,255,255,0.2);
}

.btn-login,
.btn-logout {
  background: white;
  color: #2ecc71;
  border: none;
  padding: 0.5rem 1.5rem;
  border-radius: 2rem;
  font-weight: 600;
  cursor: pointer;
  text-decoration: none;
  transition: all 0.3s;
}

.btn-login:hover,
.btn-logout:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}

/* 主内容区 */
.main-content {
  flex: 1;
  background: #f5f7fa;
}

/* 底部 */
.footer {
  background: #2c3e50;
  color: white;
  padding: 3rem 0 1rem;
}

.footer .container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.footer-links {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
  margin-bottom: 2rem;
}

.footer-section h4 {
  font-size: 1.1rem;
  margin-bottom: 1rem;
  color: #2ecc71;
}

.footer-section a {
  display: block;
  color: #bdc3c7;
  text-decoration: none;
  margin-bottom: 0.5rem;
  transition: color 0.3s;
}

.footer-section a:hover {
  color: #2ecc71;
}

.social-links {
  display: flex;
  gap: 1rem;
}

.social-icon {
  background: rgba(255,255,255,0.1);
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  font-size: 0.9rem;
}

.footer-bottom {
  border-top: 1px solid rgba(255,255,255,0.1);
  padding-top: 1rem;
  text-align: center;
  color: #95a5a6;
  font-size: 0.9rem;
}

.footer-bottom p {
  margin: 0.25rem 0;
}
</style>
