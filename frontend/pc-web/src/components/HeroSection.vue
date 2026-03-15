<template>
  <section class="hero-section">
    <div class="hero-slider">
      <div class="hero-slide">
        <div class="hero-content">
          <h1>让回收更简单 <span class="highlight">环保更有价值</span></h1>
          <p class="subtitle">智能废品回收平台，一键预约，上门回收，积分兑换</p>
          <div class="hero-actions">
            <button class="btn-primary btn-large" @click="$emit('create-order')">
              📱 立即回收
            </button>
            <button class="btn-secondary btn-large" @click="$emit('view-prices')">
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
</template>

<script>
export default {
  name: 'HeroSection',
  emits: ['create-order', 'view-prices']
}
</script>

<style scoped>
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

.btn-primary {
  padding: 16px 40px;
  font-size: 1.1rem;
  font-weight: 600;
  border-radius: 12px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  background: white;
  color: #10B981;
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.15);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
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
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: white;
  transform: translateY(-2px);
}

.btn-large {
  padding: 16px 40px;
}

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
}
</style>
