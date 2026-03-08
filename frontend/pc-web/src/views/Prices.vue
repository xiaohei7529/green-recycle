<template>
  <div class="prices-page">
    <!-- 导航栏 -->
    <NavBar />
    
    <!-- 页面头部 -->
    <section class="page-header">
      <div class="container">
        <h1>💰 回收价格</h1>
        <p>实时更新的废品回收价格，价格仅供参考，实际价格以回收员确认为准</p>
      </div>
    </section>

    <!-- 价格筛选 -->
    <section class="filter-section">
      <div class="container">
        <div class="filter-tabs">
          <button 
            :class="['filter-tab', { active: activeFilter === 'all' }]" 
            @click="activeFilter = 'all'"
          >
            全部
          </button>
          <button 
            :class="['filter-tab', { active: activeFilter === 'paper' }]" 
            @click="activeFilter = 'paper'"
          >
            📄 纸类
          </button>
          <button 
            :class="['filter-tab', { active: activeFilter === 'plastic' }]" 
            @click="activeFilter = 'plastic'"
          >
            🥤 塑料
          </button>
          <button 
            :class="['filter-tab', { active: activeFilter === 'metal' }]" 
            @click="activeFilter = 'metal'"
          >
            🔩 金属
          </button>
          <button 
            :class="['filter-tab', { active: activeFilter === 'glass' }]" 
            @click="activeFilter = 'glass'"
          >
            🫙 玻璃
          </button>
          <button 
            :class="['filter-tab', { active: activeFilter === 'textile' }]" 
            @click="activeFilter = 'textile'"
          >
            👕 纺织
          </button>
        </div>
      </div>
    </section>

    <!-- 价格列表 -->
    <section class="prices-section">
      <div class="container">
        <div class="price-grid">
          <div class="price-card" v-for="price in filteredPrices" :key="price.id">
            <div class="price-header">
              <span class="price-icon">{{ price.icon }}</span>
              <div class="price-category">{{ price.category }}</div>
            </div>
            <div class="price-name">{{ price.name }}</div>
            <div class="price-value">
              <span class="current">¥{{ price.price }}</span>
              <span class="unit">/kg</span>
            </div>
            <div class="price-change" :class="price.change >= 0 ? 'up' : 'down'">
              <span class="arrow">{{ price.change >= 0 ? '↑' : '↓' }}</span>
              <span class="percent">{{ Math.abs(price.change) }}%</span>
              <span class="text">{{ price.change >= 0 ? '较昨日' : '较昨日' }}</span>
            </div>
            <div class="price-update">更新于：{{ price.updateTime }}</div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="filteredPrices.length === 0" class="empty-state">
          <div class="empty-icon">📭</div>
          <div class="empty-text">暂无价格信息</div>
        </div>
      </div>
    </section>

    <!-- 价格说明 -->
    <section class="info-section">
      <div class="container">
        <h2>💡 价格说明</h2>
        <div class="info-grid">
          <div class="info-card">
            <div class="info-icon">📊</div>
            <h3>市场波动</h3>
            <p>回收价格受市场供需影响，每日更新，请以实际回收时价格为准</p>
          </div>
          <div class="info-card">
            <div class="info-icon">⚖️</div>
            <h3>称重标准</h3>
            <p>回收员使用经过校验的电子秤，确保称重准确，透明公正</p>
          </div>
          <div class="info-card">
            <div class="info-icon">💵</div>
            <h3>结算方式</h3>
            <p>支持微信、支付宝、银行卡等多种支付方式，即时到账</p>
          </div>
          <div class="info-card">
            <div class="info-icon">🎁</div>
            <h3>积分奖励</h3>
            <p>每次回收可获得积分，积分可兑换精美礼品或抵扣现金</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'PricesPage',
  components: {
    NavBar
  },
  data() {
    return {
      activeFilter: 'all',
      prices: [
        // 纸类
        { id: 1, category: '纸类', name: '报纸', price: 1.5, change: 5, icon: '📰', updateTime: '2026-03-08 08:00' },
        { id: 2, category: '纸类', name: '纸箱', price: 1.2, change: -3, icon: '📦', updateTime: '2026-03-08 08:00' },
        { id: 3, category: '纸类', name: '书本', price: 1.8, change: 2, icon: '📚', updateTime: '2026-03-08 08:00' },
        { id: 4, category: '纸类', name: '纸板', price: 1.0, change: 0, icon: '🗂️', updateTime: '2026-03-08 08:00' },
        
        // 塑料
        { id: 5, category: '塑料', name: 'PET 瓶', price: 2.0, change: 8, icon: '🥤', updateTime: '2026-03-08 08:00' },
        { id: 6, category: '塑料', name: '塑料桶', price: 2.5, change: 3, icon: '🪣', updateTime: '2026-03-08 08:00' },
        { id: 7, category: '塑料', name: '塑料袋', price: 1.5, change: -5, icon: '🛍️', updateTime: '2026-03-08 08:00' },
        
        // 金属
        { id: 8, category: '金属', name: '铁', price: 3.5, change: 1, icon: '🔩', updateTime: '2026-03-08 08:00' },
        { id: 9, category: '金属', name: '铜', price: 45.0, change: 2, icon: '🔶', updateTime: '2026-03-08 08:00' },
        { id: 10, category: '金属', name: '铝', price: 12.0, change: -1, icon: '🥫', updateTime: '2026-03-08 08:00' },
        { id: 11, category: '金属', name: '不锈钢', price: 8.0, change: 0, icon: '🍴', updateTime: '2026-03-08 08:00' },
        
        // 玻璃
        { id: 12, category: '玻璃', name: '玻璃瓶', price: 0.8, change: 0, icon: '🫙', updateTime: '2026-03-08 08:00' },
        { id: 13, category: '玻璃', name: '平板玻璃', price: 1.2, change: -2, icon: '🪟', updateTime: '2026-03-08 08:00' },
        
        // 纺织
        { id: 14, category: '纺织', name: '旧衣服', price: 3.0, change: 5, icon: '👕', updateTime: '2026-03-08 08:00' },
        { id: 15, category: '纺织', name: '床单被罩', price: 2.5, change: 3, icon: '🛏️', updateTime: '2026-03-08 08:00' },
      ]
    }
  },
  computed: {
    filteredPrices() {
      if (this.activeFilter === 'all') {
        return this.prices
      }
      return this.prices.filter(price => price.category === this.getCategory(this.activeFilter))
    }
  },
  methods: {
    getCategory(filter) {
      const map = {
        'paper': '纸类',
        'plastic': '塑料',
        'metal': '金属',
        'glass': '玻璃',
        'textile': '纺织'
      }
      return map[filter] || ''
    }
  }
}
</script>

<style scoped>
.prices-page {
  min-height: 100vh;
  background: #F9FAFB;
  padding-top: 70px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

/* Page Header */
.page-header {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  padding: 4rem 0;
  text-align: center;
}

.page-header h1 {
  font-size: 2.5rem;
  font-weight: 800;
  margin-bottom: 1rem;
}

.page-header p {
  font-size: 1.1rem;
  opacity: 0.9;
  max-width: 600px;
  margin: 0 auto;
}

/* Filter Section */
.filter-section {
  padding: 2rem 0;
  background: white;
  border-bottom: 1px solid #E5E7EB;
}

.filter-tabs {
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.filter-tab {
  padding: 12px 24px;
  background: white;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 500;
  color: #6B7280;
  cursor: pointer;
  transition: all 0.2s;
}

.filter-tab:hover {
  border-color: #10B981;
  color: #10B981;
}

.filter-tab.active {
  background: #10B981;
  border-color: #10B981;
  color: white;
}

/* Price Grid */
.prices-section {
  padding: 3rem 0;
}

.price-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.price-card {
  background: white;
  border-radius: 16px;
  padding: 1.5rem;
  transition: all 0.3s ease;
  border: 1px solid #E5E7EB;
  position: relative;
  overflow: hidden;
}

.price-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #10B981 0%, #059669 100%);
  opacity: 0;
  transition: opacity 0.3s;
}

.price-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.1);
  border-color: #10B981;
}

.price-card:hover::before {
  opacity: 1;
}

.price-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 1rem;
}

.price-icon {
  font-size: 2rem;
}

.price-category {
  font-size: 0.9rem;
  font-weight: 600;
  color: #10B981;
  background: #ECFDF5;
  padding: 4px 12px;
  border-radius: 20px;
}

.price-name {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 1rem;
}

.price-value {
  display: flex;
  align-items: baseline;
  gap: 4px;
  margin-bottom: 1rem;
}

.price-value .current {
  font-size: 2rem;
  font-weight: 800;
  color: #EF4444;
}

.price-value .unit {
  font-size: 0.9rem;
  color: #9CA3AF;
}

.price-change {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.9rem;
  margin-bottom: 1rem;
  padding: 8px 12px;
  border-radius: 8px;
}

.price-change.up {
  background: #DCFCE7;
  color: #166534;
}

.price-change.down {
  background: #FEF2F2;
  color: #991B1B;
}

.price-change .arrow {
  font-weight: 700;
  font-size: 1rem;
}

.price-change .percent {
  font-weight: 600;
}

.price-change .text {
  opacity: 0.7;
}

.price-update {
  font-size: 0.85rem;
  color: #9CA3AF;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 4rem 0;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.empty-text {
  font-size: 1.1rem;
  color: #6B7280;
}

/* Info Section */
.info-section {
  padding: 4rem 0;
  background: white;
}

.info-section h2 {
  text-align: center;
  font-size: 2rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 3rem;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.info-card {
  text-align: center;
  padding: 2rem;
  background: #F9FAFB;
  border-radius: 16px;
  transition: all 0.3s;
}

.info-card:hover {
  background: #ECFDF5;
  transform: translateY(-4px);
}

.info-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.info-card h3 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 0.75rem;
}

.info-card p {
  color: #6B7280;
  line-height: 1.6;
}

/* Responsive */
@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .filter-tabs {
    gap: 0.5rem;
  }

  .filter-tab {
    padding: 10px 16px;
    font-size: 0.9rem;
  }

  .price-grid {
    grid-template-columns: 1fr;
  }
}
</style>
