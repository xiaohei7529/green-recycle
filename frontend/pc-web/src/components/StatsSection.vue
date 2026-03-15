<template>
  <section class="stats-section">
    <div class="container">
      <div class="stats-header">
        <h2>📊 数据统计</h2>
        <p>实时追踪回收数据，为环保贡献力量</p>
      </div>
      <div class="stats-grid">
        <div 
          class="stat-card" 
          v-for="stat in stats" 
          :key="stat.label"
          @mouseenter="hoveredStat = stat.label"
          @mouseleave="hoveredStat = null"
        >
          <div class="stat-icon">{{ stat.icon }}</div>
          <div class="stat-value">
            <CountUp 
              :end="stat.value" 
              :duration="2"
              :decimals="stat.decimals || 0"
              :prefix="stat.prefix"
              :suffix="stat.suffix"
            />
          </div>
          <div class="stat-label">{{ stat.label }}</div>
          <div class="stat-trend" :class="stat.trend">
            <span>{{ stat.trendText }}</span>
            <span class="trend-arrow">{{ stat.trend === 'up' ? '↑' : '↓' }}</span>
          </div>
        </div>
      </div>
      <div class="stats-footer">
        <router-link to="/dashboard" class="view-more">
          查看详细数据看板 →
        </router-link>
      </div>
    </div>
  </section>
</template>

<script>
// 简单的数字滚动组件
const CountUp = {
  props: ['end', 'duration', 'decimals', 'prefix', 'suffix'],
  data() {
    return {
      displayValue: 0
    }
  },
  mounted() {
    this.animate()
  },
  methods: {
    animate() {
      const start = 0
      const end = parseFloat(this.end)
      const duration = this.duration * 1000
      const increment = end / (duration / 16)
      
      const timer = setInterval(() => {
        this.displayValue += increment
        if (this.displayValue >= end) {
          this.displayValue = end
          clearInterval(timer)
        }
      }, 16)
    }
  },
  render() {
    const formatted = this.displayValue.toFixed(this.decimals || 0)
    return `${this.prefix || ''}${formatted}${this.suffix || ''}`
  }
}

export default {
  name: 'StatsSection',
  components: { CountUp },
  data() {
    return {
      hoveredStat: null,
      stats: [
        { 
          icon: '👥',
          value: 100000, 
          label: '注册用户',
          trend: 'up',
          trendText: '较上月 +15%',
          suffix: '+'
        },
        { 
          icon: '📦',
          value: 500000, 
          label: '回收订单',
          trend: 'up',
          trendText: '较上月 +22%',
          suffix: '+'
        },
        { 
          icon: '🏪',
          value: 1000, 
          label: '回收站点',
          trend: 'up',
          trendText: '较上月 +8%',
          suffix: '+'
        },
        { 
          icon: '♻️',
          value: 5000, 
          label: '回收废品 (吨)',
          trend: 'up',
          trendText: '较上月 +18%',
          suffix: '吨'
        },
        { 
          icon: '🌱',
          value: 12000, 
          label: '减少碳排放 (吨)',
          trend: 'up',
          trendText: '较上月 +20%',
          suffix: '吨'
        },
        { 
          icon: '💰',
          value: 850, 
          label: '用户收益 (万元)',
          trend: 'up',
          trendText: '较上月 +25%',
          prefix: '¥',
          suffix: '万'
        }
      ]
    }
  }
}
</script>

<style scoped>
.stats-section {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  padding: 5rem 0;
  position: relative;
  overflow: hidden;
}

.stats-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
  opacity: 0.3;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
  position: relative;
  z-index: 1;
}

.stats-header {
  text-align: center;
  margin-bottom: 3rem;
}

.stats-header h2 {
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.stats-header p {
  font-size: 1.1rem;
  opacity: 0.9;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
}

.stat-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 2rem;
  border-radius: 16px;
  text-align: center;
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s ease;
}

.stat-card:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-4px);
}

.stat-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: 800;
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 1rem;
  opacity: 0.9;
  margin-bottom: 0.75rem;
}

.stat-trend {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 0.85rem;
  background: rgba(255, 255, 255, 0.2);
}

.stat-trend.up {
  color: #86EFAC;
}

.stat-trend.down {
  color: #FCA5A5;
}

.trend-arrow {
  font-weight: 700;
}

.stats-footer {
  text-align: center;
  padding-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.2);
}

.view-more {
  display: inline-block;
  padding: 12px 32px;
  background: white;
  color: #10B981;
  font-weight: 600;
  border-radius: 12px;
  text-decoration: none;
  transition: all 0.3s ease;
}

.view-more:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
  }
  
  .stat-value {
    font-size: 1.75rem;
  }
}
</style>
