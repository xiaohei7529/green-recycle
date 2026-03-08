<template>
  <nav class="navbar" :class="{ 'scrolled': isScrolled, 'mobile-open': isMobileMenuOpen }">
    <div class="navbar-container">
      <!-- Logo -->
      <router-link to="/" class="navbar-logo">
        <div class="logo-icon">
          <svg viewBox="0 0 100 100" width="40" height="40">
            <circle cx="50" cy="50" r="45" fill="#10B981" opacity="0.1"/>
            <circle cx="50" cy="50" r="35" fill="none" stroke="#10B981" stroke-width="3"/>
            <path d="M50 20 L50 50 L70 65" fill="none" stroke="#10B981" stroke-width="3" stroke-linecap="round"/>
            <circle cx="50" cy="50" r="8" fill="#10B981"/>
          </svg>
        </div>
        <span class="logo-text">Green Recycle</span>
      </router-link>

      <!-- Desktop Navigation -->
      <div class="navbar-menu">
        <router-link to="/" class="nav-link" exact>首页</router-link>
        <router-link to="/prices" class="nav-link">回收价格</router-link>
        <router-link to="/order" class="nav-link">预约回收</router-link>
        <router-link to="/stations" class="nav-link">回收站点</router-link>
        <router-link to="/about" class="nav-link">关于我们</router-link>
      </div>

      <!-- Action Buttons -->
      <div class="navbar-actions">
        <router-link to="/login" class="btn-login">登录</router-link>
        <router-link to="/register" class="btn-register">注册</router-link>
      </div>

      <!-- Mobile Menu Button -->
      <button class="mobile-menu-btn" @click="toggleMobileMenu">
        <span></span>
        <span></span>
        <span></span>
      </button>
    </div>

    <!-- Mobile Menu -->
    <div class="mobile-menu" v-if="isMobileMenuOpen">
      <router-link to="/" class="mobile-nav-link" @click="closeMobileMenu">首页</router-link>
      <router-link to="/prices" class="mobile-nav-link" @click="closeMobileMenu">回收价格</router-link>
      <router-link to="/order" class="mobile-nav-link" @click="closeMobileMenu">预约回收</router-link>
      <router-link to="/stations" class="mobile-nav-link" @click="closeMobileMenu">回收站点</router-link>
      <router-link to="/about" class="mobile-nav-link" @click="closeMobileMenu">关于我们</router-link>
      <div class="mobile-auth">
        <router-link to="/login" class="btn-login" @click="closeMobileMenu">登录</router-link>
        <router-link to="/register" class="btn-register" @click="closeMobileMenu">注册</router-link>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'NavBar',
  data() {
    return {
      isScrolled: false,
      isMobileMenuOpen: false
    }
  },
  mounted() {
    window.addEventListener('scroll', this.handleScroll)
  },
  beforeUnmount() {
    window.removeEventListener('scroll', this.handleScroll)
  },
  methods: {
    handleScroll() {
      this.isScrolled = window.scrollY > 20
    },
    toggleMobileMenu() {
      this.isMobileMenuOpen = !this.isMobileMenuOpen
    },
    closeMobileMenu() {
      this.isMobileMenuOpen = false
    }
  }
}
</script>

<style scoped>
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.navbar.scrolled {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  background: rgba(255, 255, 255, 0.98);
}

.navbar-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
  height: 70px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

/* Logo */
.navbar-logo {
  display: flex;
  align-items: center;
  gap: 12px;
  text-decoration: none;
  color: #111827;
  font-weight: 700;
  font-size: 20px;
  transition: opacity 0.2s;
}

.navbar-logo:hover {
  opacity: 0.8;
}

.logo-icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-text {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Desktop Menu */
.navbar-menu {
  display: flex;
  align-items: center;
  gap: 8px;
}

.nav-link {
  padding: 10px 16px;
  text-decoration: none;
  color: #4B5563;
  font-weight: 500;
  border-radius: 8px;
  transition: all 0.2s;
  position: relative;
}

.nav-link:hover {
  color: #10B981;
  background: #ECFDF5;
}

.nav-link.router-link-active {
  color: #10B981;
  background: #ECFDF5;
}

.nav-link.router-link-active::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 50%;
  transform: translateX(-50%);
  width: 20px;
  height: 2px;
  background: #10B981;
  border-radius: 2px;
}

/* Action Buttons */
.navbar-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.btn-login {
  padding: 10px 20px;
  text-decoration: none;
  color: #10B981;
  font-weight: 600;
  border-radius: 8px;
  transition: all 0.2s;
  border: 2px solid transparent;
}

.btn-login:hover {
  background: #ECFDF5;
}

.btn-register {
  padding: 10px 24px;
  text-decoration: none;
  color: white;
  font-weight: 600;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  border-radius: 8px;
  transition: all 0.2s;
  box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
}

.btn-register:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

/* Mobile Menu Button */
.mobile-menu-btn {
  display: none;
  flex-direction: column;
  gap: 5px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 8px;
  z-index: 1001;
}

.mobile-menu-btn span {
  width: 24px;
  height: 2px;
  background: #111827;
  border-radius: 2px;
  transition: all 0.3s;
}

.mobile-menu-btn.active span:nth-child(1) {
  transform: rotate(45deg) translate(5px, 5px);
}

.mobile-menu-btn.active span:nth-child(2) {
  opacity: 0;
}

.mobile-menu-btn.active span:nth-child(3) {
  transform: rotate(-45deg) translate(7px, -6px);
}

/* Mobile Menu */
.mobile-menu {
  display: none;
  position: absolute;
  top: 70px;
  left: 0;
  right: 0;
  background: white;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  padding: 24px;
  animation: slideDown 0.3s ease;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.mobile-nav-link {
  display: block;
  padding: 14px 0;
  text-decoration: none;
  color: #111827;
  font-weight: 500;
  font-size: 16px;
  border-bottom: 1px solid #F3F4F6;
  transition: color 0.2s;
}

.mobile-nav-link:hover {
  color: #10B981;
}

.mobile-auth {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 20px;
}

.mobile-auth .btn-login,
.mobile-auth .btn-register {
  text-align: center;
  padding: 14px 24px;
}

/* Responsive */
@media (max-width: 768px) {
  .navbar-menu,
  .navbar-actions {
    display: none;
  }

  .mobile-menu-btn {
    display: flex;
  }

  .mobile-menu {
    display: block;
  }

  .navbar-container {
    padding: 0 16px;
  }
}
</style>
