<template>
  <div class="orders-page">
    <NavBar />
    
    <div class="container">
      <div class="page-header">
        <h1>📦 我的订单</h1>
        <router-link to="/order/create" class="btn-create">
          + 创建订单
        </router-link>
      </div>

      <!-- 筛选和搜索 -->
      <div class="filter-bar">
        <div class="filter-group">
          <label>状态筛选：</label>
          <select v-model="filters.status" @change="loadOrders" class="filter-select">
            <option value="all">全部状态</option>
            <option value="0">待接单</option>
            <option value="1">已接单</option>
            <option value="2">回收中</option>
            <option value="3">已完成</option>
            <option value="4">已取消</option>
          </select>
        </div>

        <div class="filter-group">
          <label>时间范围：</label>
          <select v-model="filters.timeRange" @change="loadOrders" class="filter-select">
            <option value="all">全部时间</option>
            <option value="7">最近 7 天</option>
            <option value="30">最近 30 天</option>
            <option value="90">最近 90 天</option>
          </select>
        </div>

        <div class="search-group">
          <input 
            v-model="searchQuery"
            type="text"
            placeholder="搜索订单号..."
            class="search-input"
            @keyup.enter="loadOrders"
          />
          <button @click="loadOrders" class="btn-search">
            🔍 搜索
          </button>
        </div>
      </div>

      <!-- 批量操作 -->
      <div class="batch-operations" v-if="selectedOrders.length > 0">
        <span class="selected-count">已选择 {{ selectedOrders.length }} 个订单</span>
        <button @click="batchExport" class="btn-batch">
          📥 导出选中
        </button>
        <button @click="cancelSelection" class="btn-batch">
          取消选择
        </button>
      </div>

      <!-- 订单列表 -->
      <div class="orders-list">
        <div 
          v-for="order in orders" 
          :key="order.id"
          class="order-card"
          :class="{ selected: selectedOrders.includes(order.id) }"
        >
          <div class="order-header">
            <div class="order-checkbox">
              <input 
                type="checkbox" 
                :value="order.id"
                v-model="selectedOrders"
              />
            </div>
            <div class="order-info">
              <span class="order-no">订单号：{{ order.orderNo }}</span>
              <span class="order-date">{{ formatDate(order.createdAt) }}</span>
            </div>
            <div class="order-status" :class="`status-${order.status}`">
              {{ statusText(order.status) }}
            </div>
          </div>

          <div class="order-body">
            <div class="order-items">
              <div 
                v-for="item in order.items" 
                :key="item.category"
                class="order-item"
              >
                <span class="item-category">{{ item.category }}</span>
                <span class="item-weight">{{ item.weight }}kg</span>
                <span class="item-price">¥{{ item.price }}/kg</span>
                <span class="item-amount">¥{{ (item.weight * item.price).toFixed(2) }}</span>
              </div>
            </div>

            <div class="order-summary">
              <div class="summary-row">
                <span>总重量：</span>
                <span class="weight">{{ order.totalWeight }}kg</span>
              </div>
              <div class="summary-row">
                <span>总金额：</span>
                <span class="amount">¥{{ order.totalAmount.toFixed(2) }}</span>
              </div>
            </div>

            <div class="order-address">
              <span class="icon">📍</span>
              {{ order.address }}
            </div>
          </div>

          <div class="order-footer">
            <div class="order-actions">
              <button 
                v-if="order.status === 0"
                @click="cancelOrder(order.id)"
                class="btn-action btn-cancel"
              >
                取消订单
              </button>
              <button 
                v-if="order.status === 3"
                @click="reviewOrder(order.id)"
                class="btn-action btn-review"
              >
                评价
              </button>
              <button 
                @click="viewDetail(order.id)"
                class="btn-action btn-detail"
              >
                查看详情
              </button>
              <button 
                @click="exportOrder(order.id)"
                class="btn-action btn-export"
              >
                导出
              </button>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="orders.length === 0" class="empty-state">
          <div class="empty-icon">📦</div>
          <h3>暂无订单</h3>
          <p>您还没有创建任何订单</p>
          <router-link to="/order/create" class="btn-create-order">
            立即创建订单
          </router-link>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination" v-if="totalPages > 1">
        <button 
          @click="changePage(currentPage - 1)"
          :disabled="currentPage === 1"
          class="btn-page"
        >
          上一页
        </button>
        <span class="page-info">
          第 {{ currentPage }} / {{ totalPages }} 页
        </span>
        <button 
          @click="changePage(currentPage + 1)"
          :disabled="currentPage === totalPages"
          class="btn-page"
        >
          下一页
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'OrdersPage',
  components: { NavBar },
  data() {
    return {
      orders: [],
      selectedOrders: [],
      filters: {
        status: 'all',
        timeRange: 'all'
      },
      searchQuery: '',
      currentPage: 1,
      pageSize: 10,
      total: 0,
      loading: false
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.total / this.pageSize)
    }
  },
  mounted() {
    this.loadOrders()
  },
  methods: {
    async loadOrders() {
      this.loading = true
      
      try {
        // TODO: 调用真实 API
        // const response = await this.$api.get('/orders', {
        //   params: {
        //     status: this.filters.status !== 'all' ? this.filters.status : undefined,
        //     time_range: this.filters.timeRange !== 'all' ? this.filters.timeRange : undefined,
        //     search: this.searchQuery,
        //     page: this.currentPage,
        //     page_size: this.pageSize
        //   }
        // })
        
        // 模拟数据
        setTimeout(() => {
          this.orders = [
            {
              id: 1,
              orderNo: 'ORD1710518400abc123',
              createdAt: '2026-03-15 14:30:00',
              status: 0,
              items: [
                { category: '废纸', weight: 10, price: 1.5 },
                { category: '塑料', weight: 5, price: 2.0 }
              ],
              totalWeight: 15,
              totalAmount: 25,
              address: '北京市朝阳区 XX 街道 XX 小区 1 号楼'
            }
          ]
          this.total = 1
          this.loading = false
        }, 500)
      } catch (error) {
        console.error('加载订单失败:', error)
        this.loading = false
      }
    },
    
    statusText(status) {
      const map = {
        0: '待接单',
        1: '已接单',
        2: '回收中',
        3: '已完成',
        4: '已取消'
      }
      return map[status] || '未知'
    },
    
    formatDate(dateStr) {
      const date = new Date(dateStr)
      return date.toLocaleString('zh-CN')
    },
    
    changePage(page) {
      if (page < 1 || page > this.totalPages) return
      this.currentPage = page
      this.loadOrders()
    },
    
    cancelOrder(orderId) {
      if (!confirm('确定要取消这个订单吗？')) return
      // TODO: 调用 API 取消订单
      console.log('取消订单:', orderId)
    },
    
    viewDetail(orderId) {
      this.$router.push(`/orders/${orderId}`)
    },
    
    reviewOrder(orderId) {
      this.$router.push(`/orders/${orderId}/review`)
    },
    
    exportOrder(orderId) {
      // TODO: 导出订单
      console.log('导出订单:', orderId)
    },
    
    batchExport() {
      // TODO: 批量导出
      console.log('批量导出:', this.selectedOrders)
    },
    
    cancelSelection() {
      this.selectedOrders = []
    }
  }
}
</script>

<style scoped>
.orders-page {
  min-height: 100vh;
  background: #F9FAFB;
  padding-top: 70px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 24px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.page-header h1 {
  font-size: 2rem;
  font-weight: 800;
  color: #111827;
}

.btn-create {
  padding: 12px 24px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  border-radius: 12px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s;
}

.btn-create:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.3);
}

/* Filter Bar */
.filter-bar {
  background: white;
  padding: 1.5rem;
  border-radius: 16px;
  margin-bottom: 1.5rem;
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
  align-items: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.filter-group label {
  font-weight: 600;
  color: #374151;
  font-size: 0.95rem;
}

.filter-select {
  padding: 10px 16px;
  border: 2px solid #E5E7EB;
  border-radius: 10px;
  font-size: 0.95rem;
  cursor: pointer;
  transition: all 0.2s;
}

.filter-select:focus {
  border-color: #10B981;
  outline: none;
}

.search-group {
  display: flex;
  gap: 0.75rem;
  margin-left: auto;
}

.search-input {
  padding: 10px 16px;
  border: 2px solid #E5E7EB;
  border-radius: 10px;
  font-size: 0.95rem;
  width: 250px;
  transition: all 0.2s;
}

.search-input:focus {
  border-color: #10B981;
  outline: none;
}

.btn-search {
  padding: 10px 20px;
  background: #10B981;
  color: white;
  border: none;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-search:hover {
  background: #059669;
}

/* Batch Operations */
.batch-operations {
  background: #ECFDF5;
  padding: 1rem 1.5rem;
  border-radius: 12px;
  margin-bottom: 1.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.selected-count {
  font-weight: 600;
  color: #059669;
}

.btn-batch {
  padding: 8px 16px;
  background: white;
  color: #10B981;
  border: 2px solid #10B981;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-batch:hover {
  background: #10B981;
  color: white;
}

/* Orders List */
.orders-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.order-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  transition: all 0.3s;
  border: 2px solid transparent;
}

.order-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
}

.order-card.selected {
  border-color: #10B981;
  background: #ECFDF5;
}

.order-header {
  padding: 1.25rem 1.5rem;
  background: #F9FAFB;
  border-bottom: 1px solid #E5E7EB;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.order-checkbox input {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.order-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.order-no {
  font-weight: 600;
  color: #111827;
}

.order-date {
  font-size: 0.875rem;
  color: #6B7280;
}

.order-status {
  padding: 6px 16px;
  border-radius: 20px;
  font-weight: 600;
  font-size: 0.875rem;
}

.order-status.status-0 { background: #FEF3C7; color: #92400E; }
.order-status.status-1 { background: #DBEAFE; color: #1E40AF; }
.order-status.status-2 { background: #E0E7FF; color: #3730A3; }
.order-status.status-3 { background: #D1FAE5; color: #065F46; }
.order-status.status-4 { background: #F3F4F6; color: #374151; }

.order-body {
  padding: 1.5rem;
}

.order-items {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
}

.order-item {
  display: grid;
  grid-template-columns: 1fr auto auto auto;
  gap: 1rem;
  padding: 0.75rem;
  background: #F9FAFB;
  border-radius: 8px;
  font-size: 0.95rem;
}

.item-category {
  font-weight: 600;
  color: #111827;
}

.item-weight, .item-price, .item-amount {
  color: #6B7280;
}

.item-amount {
  font-weight: 600;
  color: #10B981;
}

.order-summary {
  display: flex;
  justify-content: flex-end;
  gap: 2rem;
  padding: 1rem;
  background: #F9FAFB;
  border-radius: 8px;
  margin-bottom: 1rem;
}

.summary-row {
  display: flex;
  gap: 0.5rem;
  font-size: 0.95rem;
}

.summary-row .weight {
  font-weight: 600;
  color: #374151;
}

.summary-row .amount {
  font-weight: 700;
  color: #10B981;
  font-size: 1.1rem;
}

.order-address {
  display: flex;
  align-items: flex-start;
  gap: 0.5rem;
  padding: 1rem;
  background: #F0FDF4;
  border-radius: 8px;
  font-size: 0.95rem;
  color: #374151;
}

.order-address .icon {
  font-size: 1.1rem;
}

.order-footer {
  padding: 1rem 1.5rem;
  border-top: 1px solid #E5E7EB;
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
}

.order-actions {
  display: flex;
  gap: 0.75rem;
}

.btn-action {
  padding: 8px 16px;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
}

.btn-cancel {
  background: #FEE2E2;
  color: #DC2626;
}

.btn-cancel:hover {
  background: #FECACA;
}

.btn-review {
  background: #FDE68A;
  color: #92400E;
}

.btn-review:hover {
  background: #FCD34D;
}

.btn-detail {
  background: #DBEAFE;
  color: #1E40AF;
}

.btn-detail:hover {
  background: #BFDBFE;
}

.btn-export {
  background: #F3F4F6;
  color: #374151;
}

.btn-export:hover {
  background: #E5E7EB;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  background: white;
  border-radius: 16px;
}

.empty-icon {
  font-size: 5rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.empty-state h3 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 0.5rem;
}

.empty-state p {
  color: #6B7280;
  margin-bottom: 2rem;
}

.btn-create-order {
  display: inline-block;
  padding: 12px 32px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  border-radius: 12px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s;
}

.btn-create-order:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.3);
}

/* Pagination */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  margin-top: 2rem;
  padding: 1.5rem;
}

.btn-page {
  padding: 10px 20px;
  background: white;
  border: 2px solid #E5E7EB;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-page:hover:not(:disabled) {
  border-color: #10B981;
  color: #10B981;
}

.btn-page:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-weight: 600;
  color: #6B7280;
}
</style>
