<template>
  <div class="profile-page">
    <!-- 导航栏 -->
    <NavBar />
    
    <!-- 用户信息卡片 -->
    <section class="user-header">
      <div class="container">
        <div class="user-card">
          <div class="avatar">
            <img :src="user.avatar" alt="用户头像" />
          </div>
          <div class="user-info">
            <h1>{{ user.nickname }}</h1>
            <p class="phone">{{ user.phone }}</p>
            <div class="user-stats">
              <div class="stat">
                <div class="value">15</div>
                <div class="label">订单数</div>
              </div>
              <div class="stat">
                <div class="value">1250</div>
                <div class="label">积分</div>
              </div>
              <div class="stat">
                <div class="value">¥358.50</div>
                <div class="label">累计收益</div>
              </div>
            </div>
          </div>
          <button class="btn-edit" @click="editProfile">
            ✏️ 编辑资料
          </button>
        </div>
      </div>
    </section>

    <!-- 功能菜单 -->
    <section class="menu-section">
      <div class="container">
        <!-- 订单管理 -->
        <div class="menu-group">
          <div class="menu-header">
            <span class="icon">📦</span>
            <span>订单管理</span>
          </div>
          <div class="menu-list">
            <div class="menu-item" @click="goTo('/orders')">
              <span class="item-icon">📋</span>
              <span class="item-label">我的订单</span>
              <span class="item-arrow">›</span>
            </div>
            <div class="menu-item" @click="goTo('/orders/pending')">
              <span class="item-icon">⏳</span>
              <span class="item-label">待处理订单</span>
              <span class="item-badge">2</span>
              <span class="item-arrow">›</span>
            </div>
          </div>
        </div>

        <!-- 资产管理 -->
        <div class="menu-group">
          <div class="menu-header">
            <span class="icon">💰</span>
            <span>资产管理</span>
          </div>
          <div class="menu-list">
            <div class="menu-item" @click="goTo('/wallet')">
              <span class="item-icon">👛</span>
              <span class="item-label">我的钱包</span>
              <span class="item-arrow">›</span>
            </div>
            <div class="menu-item" @click="goTo('/points')">
              <span class="item-icon">🎁</span>
              <span class="item-label">积分商城</span>
              <span class="item-arrow">›</span>
            </div>
            <div class="menu-item" @click="goTo('/coupon')">
              <span class="item-icon">🎫</span>
              <span class="item-label">优惠券</span>
              <span class="item-badge">3</span>
              <span class="item-arrow">›</span>
            </div>
          </div>
        </div>

        <!-- 常用功能 -->
        <div class="menu-group">
          <div class="menu-header">
            <span class="icon">🛠️</span>
            <span>常用功能</span>
          </div>
          <div class="menu-list">
            <div class="menu-item" @click="goTo('/addresses')">
              <span class="item-icon">📍</span>
              <span class="item-label">地址管理</span>
              <span class="item-arrow">›</span>
            </div>
            <div class="menu-item" @click="goTo('/favorite')">
              <span class="item-icon">⭐</span>
              <span class="item-label">收藏夹</span>
              <span class="item-arrow">›</span>
            </div>
            <div class="menu-item" @click="goTo('/history')">
              <span class="item-icon">📊</span>
              <span class="item-label">回收记录</span>
              <span class="item-arrow">›</span>
            </div>
          </div>
        </div>

        <!-- 设置与帮助 -->
        <div class="menu-group">
          <div class="menu-header">
            <span class="icon">⚙️</span>
            <span>设置与帮助</span>
          </div>
          <div class="menu-list">
            <div class="menu-item" @click="goTo('/settings')">
              <span class="item-icon">🔧</span>
              <span class="item-label">设置</span>
              <span class="item-arrow">›</span>
            </div>
            <div class="menu-item" @click="goTo('/help')">
              <span class="item-icon">❓</span>
              <span class="item-label">帮助中心</span>
              <span class="item-arrow">›</span>
            </div>
            <div class="menu-item" @click="goTo('/feedback')">
              <span class="item-icon">💬</span>
              <span class="item-label">意见反馈</span>
              <span class="item-arrow">›</span>
            </div>
            <div class="menu-item" @click="goTo('/about')">
              <span class="item-icon">ℹ️</span>
              <span class="item-label">关于我们</span>
              <span class="item-arrow">›</span>
            </div>
          </div>
        </div>

        <!-- 退出登录 -->
        <div class="logout-section">
          <button class="btn-logout" @click="logout">
            🚪 退出登录
          </button>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'ProfilePage',
  components: {
    NavBar
  },
  data() {
    return {
      user: {
        nickname: '张先生',
        phone: '138****8000',
        avatar: '/avatars/user1.svg'
      }
    }
  },
  methods: {
    goTo(path) {
      this.$router.push(path)
    },
    editProfile() {
      this.$router.push('/profile/edit')
    },
    logout() {
      if (confirm('确定要退出登录吗？')) {
        console.log('退出登录')
        this.$router.push('/login')
      }
    }
  }
}
</script>

<style scoped>
.profile-page {
  min-height: 100vh;
  background: #F9FAFB;
  padding-top: 70px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

/* User Header */
.user-header {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  padding: 3rem 0;
  position: relative;
  overflow: hidden;
}

.user-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
}

.user-card {
  display: flex;
  align-items: center;
  gap: 2rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 2rem;
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  position: relative;
  z-index: 1;
}

.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  overflow: hidden;
  border: 4px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-info {
  flex: 1;
  color: white;
}

.user-info h1 {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.user-info .phone {
  font-size: 1rem;
  opacity: 0.9;
  margin-bottom: 1.5rem;
}

.user-stats {
  display: flex;
  gap: 3rem;
}

.user-stats .stat {
  text-align: center;
}

.user-stats .stat .value {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.25rem;
}

.user-stats .stat .label {
  font-size: 0.85rem;
  opacity: 0.8;
}

.btn-edit {
  padding: 12px 24px;
  background: white;
  color: #10B981;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.15);
}

.btn-edit:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
}

/* Menu Section */
.menu-section {
  padding: 2rem 0 3rem;
}

.menu-group {
  background: white;
  border-radius: 16px;
  margin-bottom: 1.5rem;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.menu-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 1rem 1.5rem;
  background: #F9FAFB;
  border-bottom: 1px solid #E5E7EB;
  font-size: 1rem;
  font-weight: 600;
  color: #111827;
}

.menu-header .icon {
  font-size: 1.2rem;
}

.menu-list {
  padding: 0.5rem 0;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 1rem 1.5rem;
  cursor: pointer;
  transition: all 0.2s;
  border-bottom: 1px solid #F3F4F6;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-item:hover {
  background: #F9FAFB;
}

.menu-item .item-icon {
  font-size: 1.2rem;
  margin-right: 12px;
  width: 24px;
  text-align: center;
}

.menu-item .item-label {
  flex: 1;
  font-size: 1rem;
  color: #374151;
}

.menu-item .item-badge {
  background: #EF4444;
  color: white;
  font-size: 0.75rem;
  font-weight: 600;
  padding: 2px 8px;
  border-radius: 10px;
  margin-right: 12px;
}

.menu-item .item-arrow {
  font-size: 1.5rem;
  color: #9CA3AF;
  line-height: 1;
}

/* Logout Section */
.logout-section {
  margin-top: 2rem;
}

.btn-logout {
  width: 100%;
  padding: 1rem;
  background: white;
  color: #EF4444;
  border: 2px solid #FEE2E2;
  border-radius: 16px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-logout:hover {
  background: #FEF2F2;
  border-color: #FECACA;
}

/* Responsive */
@media (max-width: 768px) {
  .user-card {
    flex-direction: column;
    text-align: center;
  }

  .user-stats {
    justify-content: center;
    gap: 2rem;
  }

  .btn-edit {
    width: 100%;
  }
}
</style>
