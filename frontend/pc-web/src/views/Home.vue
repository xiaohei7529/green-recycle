<template>
  <div class="home">
    <!-- 轮播图区域 -->
    <section class="hero-section">
      <div class="hero-slider">
        <div class="hero-slide active">
          <div class="hero-content">
            <h1>让回收更简单</h1>
            <p>智能废品回收平台，一键预约，上门回收</p>
            <button class="btn-primary" @click="createOrder">立即回收</button>
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
        <router-link to="/prices" class="btn-secondary">查看更多价格</router-link>
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
        <router-link to="/login" class="btn-primary btn-large">立即注册</router-link>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: 'HomePage',
  data() {
    return {
      features: [
        { icon: '📱', title: '扫码下单', description: '扫描废品二维码，快速下单预约' },
        { icon: '🗺️', title: '附近回收点', description: 'GPS 定位，显示附近回收站点' },
        { icon: '💰', title: '实时价格', description: '各类废品实时回收价格' },
        { icon: '📅', title: '预约上门', description: '选择时间，回收员准时上门' },
        { icon: '📊', title: '回收记录', description: '历史回收记录，收益统计' },
        { icon: '🏆', title: '积分系统', description: '回收得积分，兑换礼品' }
      ],
      processSteps: [
        { title: '在线下单', description: '选择废品种类和数量，预约回收时间' },
        { title: '上门回收', description: '回收员准时上门，称重确认' },
        { title: '即时结算', description: '现场结算，支持多种支付方式' },
        { title: '积分奖励', description: '获得积分，兑换精美礼品' }
      ],
      prices: [
        { category: '废纸', price: '1.5', updateTime: '2026-03-07 08:00' },
        { category: '塑料', price: '2.0', updateTime: '2026-03-07 08:00' },
        { category: '金属', price: '3.5', updateTime: '2026-03-07 08:00' },
        { category: '玻璃', price: '0.8', updateTime: '2026-03-07 08:00' }
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
          content: '公司定期使用企业回收服务，专业高效，为环保出一份力！',
          avatar: '/avatars/user3.svg'
        }
      ]
    }
  },
  methods: {
    createOrder() {
      this.$router.push('/orders/create')
    }
  }
}
</script>

<style scoped>
.home {
  background: white;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.section-title {
  text-align: center;
  font-size: 2rem;
  color: #2c3e50;
  margin-bottom: 3rem;
}

/* 轮播图区域 */
.hero-section {
  background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
  color: white;
  padding: 4rem 0;
}

.hero-slider {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.hero-content h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.hero-content p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.btn-primary {
  background: white;
  color: #2ecc71;
  border: none;
  padding: 1rem 2rem;
  border-radius: 2rem;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  text-decoration: none;
  display: inline-block;
  transition: all 0.3s;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0,0,0,0.2);
}

.hero-image img {
  max-width: 400px;
  height: auto;
}

/* 核心功能 */
.features-section {
  padding: 5rem 0;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.feature-card {
  text-align: center;
  padding: 2rem;
  border-radius: 1rem;
  background: white;
  box-shadow: 0 4px 15px rgba(0,0,0,0.1);
  transition: transform 0.3s;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.feature-card p {
  color: #7f8c8d;
}

/* 回收流程 */
.process-section {
  background: #f5f7fa;
  padding: 5rem 0;
}

.process-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
}

.process-step {
  text-align: center;
  position: relative;
}

.step-number {
  width: 60px;
  height: 60px;
  background: #2ecc71;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: bold;
  margin: 0 auto 1rem;
}

.process-step h3 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.process-step p {
  color: #7f8c8d;
}

/* 回收价格 */
.prices-section {
  padding: 5rem 0;
}

.prices-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
  margin-bottom: 2rem;
}

.price-card {
  background: white;
  border: 2px solid #2ecc71;
  border-radius: 1rem;
  padding: 2rem;
  text-align: center;
  transition: all 0.3s;
}

.price-card:hover {
  background: #2ecc71;
  color: white;
}

.price-value {
  font-size: 2.5rem;
  font-weight: bold;
  color: #2ecc71;
  margin: 1rem 0;
}

.price-value span {
  font-size: 1rem;
}

.price-card:hover .price-value {
  color: white;
}

.price-update {
  color: #95a5a6;
  font-size: 0.9rem;
}

.btn-secondary {
  display: inline-block;
  color: #2ecc71;
  border: 2px solid #2ecc71;
  padding: 0.8rem 2rem;
  border-radius: 2rem;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.3s;
}

.btn-secondary:hover {
  background: #2ecc71;
  color: white;
}

/* 数据统计 */
.stats-section {
  background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
  color: white;
  padding: 4rem 0;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
}

.stat-card {
  text-align: center;
}

.stat-value {
  font-size: 3rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 1.1rem;
  opacity: 0.9;
}

/* 用户评价 */
.testimonials-section {
  padding: 5rem 0;
  background: #f5f7fa;
}

.testimonials-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.testimonial-card {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.testimonial-content {
  font-style: italic;
  color: #2c3e50;
  margin-bottom: 1.5rem;
  line-height: 1.6;
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
  color: #2c3e50;
}

.user-location {
  color: #95a5a6;
  font-size: 0.9rem;
}

/* CTA 区域 */
.cta-section {
  background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
  color: white;
  padding: 4rem 0;
  text-align: center;
}

.cta-section h2 {
  font-size: 2rem;
  margin-bottom: 1rem;
}

.cta-section p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.btn-large {
  padding: 1.2rem 3rem;
  font-size: 1.2rem;
}
</style>
