<template>
  <div class="home">
    <!-- 导航栏 -->
    <NavBar />
    
    <!-- Hero 区域 -->
    <section class="hero-section">
      <div class="hero-slider">
        <div class="hero-slide">
          <div class="hero-content">
            <h1>让回收更简单 <span class="highlight">环保更有价值</span></h1>
            <p class="subtitle">智能废品回收平台，一键预约，上门回收，积分兑换</p>
            <div class="hero-actions">
              <button class="btn-primary btn-large" @click="createOrder">
                📱 立即回收
              </button>
              <button class="btn-secondary btn-large" @click="viewPrices">
                💰 查看价格
              </button>
            </div>
            <div class="hero-stats">
              <div class="stat">
                <span class="value">10 万+</span>
                <span class="label">注册用户</span>
              </div>
              <div class="stat">
                <span class="value">50 万+</span>
                <span class="label">回收订单</span>
              </div>
              <div class="stat">
                <span class="value">4.9★</span>
                <span class="label">用户评分</span>
              </div>
            </div>
          </div>
          <div class="hero-image">
            <img src="/images/recycle-hero.svg" alt="智能回收" />
          </div>
        </div>
      </div>
    </section>

    <!-- 核心功能 -->
    <section class="features-section">
      <div class="container">
        <h2 class="section-title">核心功能</h2>
        <div class="features-grid">
          <div class="feature-card" v-for="feature in features" :key="feature.title">
            <div class="feature-icon">{{ feature.icon }}</div>
            <h3>{{ feature.title }}</h3>
            <p>{{ feature.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 回收流程 -->
    <section class="process-section">
      <div class="container">
        <h2 class="section-title">回收流程</h2>
        <div class="process-steps">
          <div class="process-step" v-for="(step, index) in processSteps" :key="index">
            <div class="step-number">{{ index + 1 }}</div>
            <h3>{{ step.title }}</h3>
            <p>{{ step.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 回收价格 -->
    <section class="prices-section">
      <div class="container">
        <h2 class="section-title">今日回收价格</h2>
        <div class="prices-grid">
          <div class="price-card" v-for="price in prices" :key="price.category">
            <h3>{{ price.category }}</h3>
            <div class="price-value">¥{{ price.price }}<span>/kg</span></div>
            <p class="price-update">更新于：{{ price.updateTime }}</p>
          </div>
        </div>
        <router-link to="/prices" class="btn-secondary-inline">查看更多价格</router-link>
      </div>
    </section>

    <!-- 数据统计 -->
    <section class="stats-section">
      <div class="container">
        <div class="stats-grid">
          <div class="stat-card" v-for="stat in stats" :key="stat.label">
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- 用户评价 -->
    <section class="testimonials-section">
      <div class="container">
        <h2 class="section-title">用户评价</h2>
        <div class="testimonials-grid">
          <div class="testimonial-card" v-for="testimonial in testimonials" :key="testimonial.user">
            <div class="testimonial-content">"{{ testimonial.content }}"</div>
            <div class="testimonial-user">
              <img :src="testimonial.avatar" :alt="testimonial.user" />
              <div>
                <div class="user-name">{{ testimonial.user }}</div>
                <div class="user-location">{{ testimonial.location }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA 区域 -->
    <section class="cta-section">
      <div class="container">
        <h2>开始您的环保之旅</h2>
        <p>立即注册，首次回收享受双倍积分</p>
        <router-link to="/register" class="btn-primary btn-large">立即注册</router-link>
      </div>
    </section>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'HomePage',
  components: {
    NavBar
  },
  data() {
    return {
      features: [
        { icon: '📱', title: '扫码下单', description: '扫描废品二维码，快速下单预约' },
        { icon: '🗺️', title: '附近回收点', description: 'GPS 定位，显示附近回收站点' },
        { icon: '💰', title: '实时价格', description: '各类废品实时回收价格' },
        { icon: '📅', title: '预约上门', description: '选择时间，回收员准时上门' },
        { icon: '📊', title: '回收记录', description: '历史回收记录，收益统计' },
        { icon: '🏆', title: '积分系统', description: '回收得积分，兑换精美礼品' }
      ],
      processSteps: [
        { title: '在线下单', description: '选择废品种类和数量，预约回收时间' },
        { title: '上门回收', description: '回收员准时上门，称重确认' },
        { title: '即时结算', description: '现场结算，支持多种支付方式' },
        { title: '积分奖励', description: '获得积分，兑换精美礼品' }
      ],
      prices: [
        { category: '废纸', price: '1.5', updateTime: '2026-03-08 08:00' },
        { category: '塑料', price: '2.0', updateTime: '2026-03-08 08:00' },
        { category: '金属', price: '3.5', updateTime: '2026-03-08 08:00' },
        { category: '玻璃', price: '0.8', updateTime: '2026-03-08 08:00' }
      ],
      stats: [
        { value: '10 万+', label: '注册用户' },
        { value: '50 万+', label: '回收订单' },
        { value: '1000+', label: '回收站点' },
        { value: '5000 吨', label: '回收废品' }
      ],
      testimonials: [
        {
          user: '张先生',
          location: '北京市朝阳区',
          content: '非常方便，回收员准时上门，价格透明，积分还能兑换礼品！',
          avatar: '/avatars/user1.svg'
        },
        {
          user: '李女士',
          location: '上海市浦东新区',
          content: '家里堆积的废品终于有地方处理了，环保又有收益，强烈推荐！',
          avatar: '/avatars/user2.svg'
        },
        {
          user: '王经理',
          location: '广州市天河区',
          content: '企业废品回收的好帮手，定期上门，结算及时，服务专业！',
          avatar: '/avatars/user3.svg'
        }
      ]
    }
  },
  methods: {
    createOrder() {
      this.$router.push('/order')
    },
    viewPrices() {
      this.$router.push('/prices')
    }
  }
}
</script>

<style scoped>
.home {
  background: white;
  padding-top: 70px; /* Offset for fixed navbar */
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 3rem;
}

/* Hero Section */
.hero-section {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  padding: 6rem 0;
  min-height: 600px;
  display: flex;
  align-items: center;
  position: relative;
  overflow: hidden;
}

.hero-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
  opacity: 0.3;
}

.hero-slider {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
  position: relative;
  z-index: 1;
  width: 100%;
}

.hero-slide {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 4rem;
}

.hero-content {
  flex: 1;
  text-align: left;
}

.hero-content h1 {
  font-size: 3.5rem;
  font-weight: 800;
  margin-bottom: 1.5rem;
  line-height: 1.2;
  text-shadow: 0 2px 20px rgba(0, 0, 0, 0.2);
}

.hero-content h1 .highlight {
  display: block;
  font-size: 2.5rem;
  background: linear-gradient(135deg, #FFFFFF 0%, #ECFDF5 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-top: 0.5rem;
}

.hero-content .subtitle {
  font-size: 1.25rem;
  margin-bottom: 2.5rem;
  opacity: 0.95;
  line-height: 1.6;
  max-width: 500px;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  margin-bottom: 3rem;
}

.hero-stats {
  display: flex;
  gap: 3rem;
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.2);
}

.hero-stats .stat {
  text-align: left;
}

.hero-stats .stat .value {
  display: block;
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 0.25rem;
}

.hero-stats .stat .label {
  font-size: 0.9rem;
  opacity: 0.85;
}

.hero-image {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.hero-image img {
  max-width: 450px;
  height: auto;
  animation: float 6s ease-in-out infinite;
  filter: drop-shadow(0 20px 40px rgba(0, 0, 0, 0.2));
}

@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(2deg); }
}

/* Buttons */
.btn-primary, .btn-secondary-inline {
  padding: 16px 40px;
  font-size: 1.1rem;
  font-weight: 600;
  border-radius: 12px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.15);
}

.btn-primary {
  background: white;
  color: #10B981;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
}

.btn-primary:active {
  transform: translateY(0);
}

.btn-secondary {
  background: transparent;
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.5);
  padding: 16px 40px;
  font-size: 1.1rem;
  font-weight: 600;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: white;
  transform: translateY(-2px);
}

.btn-large {
  padding: 16px 40px;
  font-size: 1.1rem;
}

.btn-secondary-inline {
  background: transparent;
  color: #10B981;
  border: 2px solid #10B981;
  margin-top: 2rem;
}

.btn-secondary-inline:hover {
  background: #10B981;
  color: white;
}

/* Features Section */
.features-section {
  padding: 6rem 0;
  background: #F9FAFB;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.feature-card {
  background: white;
  padding: 2.5rem;
  border-radius: 16px;
  text-align: center;
  transition: all 0.3s ease;
  border: 1px solid #E5E7EB;
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  border-color: #10B981;
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 0.75rem;
}

.feature-card p {
  color: #6B7280;
  line-height: 1.6;
}

/* Process Section */
.process-section {
  padding: 6rem 0;
}

.process-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 3rem;
}

.process-step {
  text-align: center;
  position: relative;
}

.step-number {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  font-size: 1.5rem;
  font-weight: 700;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.5rem;
  box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
}

.process-step h3 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 0.75rem;
}

.process-step p {
  color: #6B7280;
  line-height: 1.6;
}

/* Prices Section */
.prices-section {
  padding: 6rem 0;
  background: #F9FAFB;
}

.prices-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 2rem;
}

.price-card {
  background: white;
  border: 2px solid #10B981;
  border-radius: 16px;
  padding: 2rem;
  text-align: center;
  transition: all 0.3s ease;
}

.price-card:hover {
  background: #10B981;
  color: white;
  transform: translateY(-4px);
  box-shadow: 0 12px 30px rgba(16, 185, 129, 0.3);
}

.price-card h3 {
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 1rem;
}

.price-value {
  font-size: 2.5rem;
  font-weight: 800;
  color: #10B981;
  margin: 1rem 0;
}

.price-value span {
  font-size: 1rem;
  font-weight: 500;
}

.price-card:hover .price-value {
  color: white;
}

.price-update {
  color: #9CA3AF;
  font-size: 0.9rem;
}

.price-card:hover .price-update {
  color: rgba(255, 255, 255, 0.8);
}

/* Stats Section */
.stats-section {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  padding: 5rem 0;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 3rem;
}

.stat-card {
  text-align: center;
}

.stat-value {
  font-size: 3.5rem;
  font-weight: 800;
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 1.1rem;
  opacity: 0.9;
}

/* Testimonials Section */
.testimonials-section {
  padding: 6rem 0;
  background: #F9FAFB;
}

.testimonials-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 2rem;
}

.testimonial-card {
  background: white;
  padding: 2.5rem;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.testimonial-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.1);
}

.testimonial-content {
  font-size: 1.1rem;
  color: #374151;
  line-height: 1.7;
  margin-bottom: 2rem;
  font-style: italic;
}

.testimonial-user {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.testimonial-user img {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  object-fit: cover;
}

.user-name {
  font-weight: 600;
  color: #111827;
  margin-bottom: 0.25rem;
}

.user-location {
  font-size: 0.9rem;
  color: #6B7280;
}

/* CTA Section */
.cta-section {
  padding: 6rem 0;
  text-align: center;
}

.cta-section h2 {
  font-size: 2.5rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 1rem;
}

.cta-section p {
  font-size: 1.25rem;
  color: #6B7280;
  margin-bottom: 2.5rem;
}

/* Responsive */
@media (max-width: 768px) {
  .hero-slide {
    flex-direction: column;
    text-align: center;
  }

  .hero-content {
    text-align: center;
  }

  .hero-content h1 {
    font-size: 2.5rem;
  }

  .hero-content h1 .highlight {
    font-size: 1.75rem;
  }

  .hero-actions {
    flex-direction: column;
    justify-content: center;
  }

  .hero-stats {
    justify-content: center;
    gap: 2rem;
  }

  .hero-image img {
    max-width: 300px;
  }

  .section-title {
    font-size: 2rem;
  }

  .features-grid,
  .process-steps,
  .prices-grid,
  .testimonials-grid {
    grid-template-columns: 1fr;
  }
}
</style>
