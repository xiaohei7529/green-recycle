<template>
  <section class="features-section">
    <div class="container">
      <h2 class="section-title">核心功能</h2>
      <div class="features-grid">
        <div 
          class="feature-card" 
          v-for="feature in features" 
          :key="feature.title"
          @mouseenter="hoveredFeature = feature.title"
          @mouseleave="hoveredFeature = null"
        >
          <div class="feature-icon">{{ feature.icon }}</div>
          <h3>{{ feature.title }}</h3>
          <p>{{ feature.description }}</p>
          <div class="feature-more" v-if="hoveredFeature === feature.title">
            <router-link :to="feature.link" class="learn-more">
              了解更多 →
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'FeaturesSection',
  data() {
    return {
      hoveredFeature: null,
      features: [
        { 
          icon: '📱', 
          title: '扫码下单', 
          description: '扫描废品二维码，快速下单预约',
          link: '/order/create'
        },
        { 
          icon: '🗺️', 
          title: '附近回收点', 
          description: 'GPS 定位，显示附近回收站点',
          link: '/recyclers'
        },
        { 
          icon: '💰', 
          title: '实时价格', 
          description: '各类废品实时回收价格',
          link: '/prices'
        },
        { 
          icon: '📅', 
          title: '预约上门', 
          description: '选择时间，回收员准时上门',
          link: '/order/schedule'
        },
        { 
          icon: '📊', 
          title: '回收记录', 
          description: '历史回收记录，收益统计',
          link: '/orders'
        },
        { 
          icon: '🏆', 
          title: '积分系统', 
          description: '回收得积分，兑换精美礼品',
          link: '/points'
        }
      ]
    }
  }
}
</script>

<style scoped>
.features-section {
  padding: 6rem 0;
  background: #F9FAFB;
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
  position: relative;
  overflow: hidden;
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  border-color: #10B981;
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  transition: transform 0.3s ease;
}

.feature-card:hover .feature-icon {
  transform: scale(1.1);
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

.feature-more {
  margin-top: 1.5rem;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.3s ease;
}

.feature-card:hover .feature-more {
  opacity: 1;
  transform: translateY(0);
}

.learn-more {
  color: #10B981;
  font-weight: 600;
  text-decoration: none;
  font-size: 0.95rem;
}

.learn-more:hover {
  text-decoration: underline;
}

@media (max-width: 768px) {
  .features-grid {
    grid-template-columns: 1fr;
  }
}
</style>
