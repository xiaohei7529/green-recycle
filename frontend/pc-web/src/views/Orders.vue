<template>
  <div class="orders-page">
    
    <!-- 页面头部 -->
    <section class="page-header">
      <div class="container">
        <h1>📦 我的订单</h1>
        <p>查看和管理您的回收订单</p>
      </div>
    </section>

    <!-- 主要内容 -->
    <section class="orders-section">
      <div class="container">
        <!-- 创建订单按钮 -->
        <div class="page-actions">
          <button class="btn-create" @click="createOrder">
            <span class="icon">➕</span>
            创建订单
          </button>
        </div>

        <!-- 订单筛选 -->
        <div class="order-tabs">
          <button 
            :class="['order-tab', { active: activeTab === 'all' }]" 
            @click="activeTab = 'all'"
          >
            全部
          </button>
          <button 
            :class="['order-tab', { active: activeTab === 'pending' }]" 
            @click="activeTab = 'pending'"
          >
            待接单
          </button>
          <button 
            :class="['order-tab', { active: activeTab === 'processing' }]" 
            @click="activeTab = 'processing'"
          >
            回收中
          </button>
          <button 
            :class="['order-tab', { active: activeTab === 'completed' }]" 
            @click="activeTab = 'completed'"
          >
            已完成
          </button>
        </div>

        <!-- 订单列表 -->
        <div class="orders-list">
          <div v-if="loading" class="empty-state">
            <div class="empty-icon">⏳</div>
            <div class="empty-text">加载中...</div>
          </div>
          <div class="order-card" v-for="order in filteredOrders" :key="order.id">
            <div class="order-header">
              <div class="order-number">
                <span class="label">订单号</span>
                <span class="value">{{ order.orderNo }}</span>
              </div>
              <div class="order-status" :class="getStatusClass(order.status)">
                {{ getStatusText(order.status) }}
              </div>
            </div>

            <div class="order-body">
              <div class="order-info">
                <div class="info-row">
                  <span class="label">📋 类型</span>
                  <span class="value">{{ order.type === 1 ? '上门回收' : '站点回收' }}</span>
                </div>
                <div class="info-row">
                  <span class="label">📍 地址</span>
                  <span class="value">{{ order.address }}</span>
                </div>
                <div class="info-row">
                  <span class="label">♻️ 废品</span>
                  <span class="value">{{ order.items.join('、') }}</span>
                </div>
                <div class="info-row">
                  <span class="label">⏰ 时间</span>
                  <span class="value">{{ order.scheduledTime }}</span>
                </div>
              </div>

              <div class="order-amount">
                <div class="amount-label">订单金额</div>
                <div class="amount-value">¥{{ order.totalAmount }}</div>
              </div>
            </div>

            <div class="order-footer">
              <div class="order-time">
                <span class="icon">🕐</span>
                {{ order.createdAt }}
              </div>
              <div class="order-actions">
                <button class="btn-detail" @click="viewDetail(order)">详情</button>
                <button v-if="order.status === 0" class="btn-cancel" @click="cancelOrder(order)">取消</button>
                <button v-if="order.status === 3" class="btn-primary" @click="reviewOrder(order)">评价</button>
              </div>
            </div>
          </div>

          <!-- 空状态 -->
          <div v-if="filteredOrders.length === 0" class="empty-state">
            <div class="empty-icon">📭</div>
            <div class="empty-text">暂无订单</div>
            <button class="btn-create-order" @click="createOrder">创建第一个订单</button>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import { fetchOrders, cancelOrder } from '@/api/orders'
import { ElMessageBox, ElMessage } from 'element-plus'

export default {
  name: 'OrdersPage',
  data() {
    return {
      activeTab: 'all',
      loading: false,
      orders: []
    }
  },
  computed: {
    filteredOrders() {
      if (this.activeTab === 'all') return this.orders
      const statusMap = { pending: 0, processing: [1, 2], completed: 3 }
      const target = statusMap[this.activeTab]
      return this.orders.filter(o =>
        Array.isArray(target) ? target.includes(o.status) : o.status === target
      )
    }
  },
  async created() {
    await this.loadOrders()
  },
  methods: {
    async loadOrders() {
      this.loading = true
      try {
        const res = await fetchOrders({ page: 1, page_size: 50 })
        // 将 snake_case 字段转换为模板使用的格式
        this.orders = (res.data?.list || []).map(o => ({
          id: o.id,
          orderNo: o.order_no,
          type: o.type,
          address: [o.province, o.city, o.district, o.address].filter(Boolean).join(' '),
          items: (o.order_items || []).map(i => i.category),
          totalAmount: o.total_amount,
          status: o.status,
          scheduledTime: o.pickup_time ? o.pickup_time.replace('T', ' ').slice(0, 16) : '-',
          createdAt: o.created_at ? o.created_at.replace('T', ' ').slice(0, 16) : '-'
        }))
      } catch (err) {
        ElMessage.error(err.message || '获取订单失败')
      } finally {
        this.loading = false
      }
    },
    getStatusClass(status) {
      return { 0: 'status-pending', 1: 'status-processing', 2: 'status-processing', 3: 'status-completed', 4: 'status-cancelled' }[status] || ''
    },
    getStatusText(status) {
      return { 0: '待接单', 1: '已接单', 2: '回收中', 3: '已完成', 4: '已取消' }[status] || '未知'
    },
    createOrder() {
      this.$router.push('/order/create')
    },
    viewDetail(order) {
      this.$router.push(`/orders/${order.id}`)
    },
    async cancelOrder(order) {
      try {
        await ElMessageBox.confirm(`确定要取消订单 ${order.orderNo} 吗？`, '取消订单', {
          confirmButtonText: '确定取消',
          cancelButtonText: '我再想想',
          type: 'warning'
        })
        await cancelOrder(order.id)
        ElMessage.success('订单已取消')
        await this.loadOrders()
      } catch (err) {
        if (err !== 'cancel') ElMessage.error(err.message || '取消失败')
      }
    },
    reviewOrder(order) {
      ElMessage.info('评价功能即将上线，敬请期待')
    }
  }
}
</script>

<style scoped>
.orders-page {
  min-height: 100vh;
  background: #F9FAFB;
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
  padding: 3rem 0;
  text-align: center;
}

.page-header h1 {
  font-size: 2.5rem;
  font-weight: 800;
  margin-bottom: 0.5rem;
}

.page-header p {
  font-size: 1.1rem;
  opacity: 0.9;
}

/* Page Actions */
.page-actions {
  display: flex;
  justify-content: flex-end;
  padding: 2rem 0 1rem;
}

.btn-create {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 14px 28px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
}

.btn-create:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

.btn-create .icon {
  font-size: 1.2rem;
}

/* Order Tabs */
.order-tabs {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  border-bottom: 2px solid #E5E7EB;
  padding-bottom: 1rem;
}

.order-tab {
  padding: 10px 24px;
  background: transparent;
  border: none;
  font-size: 1rem;
  font-weight: 500;
  color: #6B7280;
  cursor: pointer;
  border-radius: 8px;
  transition: all 0.2s;
  position: relative;
}

.order-tab:hover {
  color: #10B981;
  background: #ECFDF5;
}

.order-tab.active {
  color: #10B981;
  background: #ECFDF5;
  font-weight: 600;
}

/* Orders List */
.orders-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  padding-bottom: 3rem;
}

.order-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  transition: all 0.3s;
}

.order-card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  background: #F9FAFB;
  border-bottom: 1px solid #E5E7EB;
}

.order-number {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.order-number .label {
  font-size: 0.85rem;
  color: #9CA3AF;
}

.order-number .value {
  font-size: 1rem;
  font-weight: 600;
  color: #111827;
}

.order-status {
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 0.9rem;
  font-weight: 600;
}

.order-status.status-pending {
  background: #FEF3C7;
  color: #92400E;
}

.order-status.status-processing {
  background: #DBEAFE;
  color: #1E40AF;
}

.order-status.status-completed {
  background: #D1FAE5;
  color: #065F46;
}

.order-status.status-cancelled {
  background: #F3F4F6;
  color: #6B7280;
}

.order-body {
  display: flex;
  padding: 1.5rem;
  gap: 2rem;
}

.order-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.info-row {
  display: flex;
  gap: 12px;
}

.info-row .label {
  font-size: 0.9rem;
  color: #6B7280;
  min-width: 80px;
}

.info-row .value {
  font-size: 0.95rem;
  color: #111827;
}

.order-amount {
  text-align: right;
  display: flex;
  flex-direction: column;
  justify-content: center;
  min-width: 150px;
}

.amount-label {
  font-size: 0.9rem;
  color: #9CA3AF;
  margin-bottom: 0.5rem;
}

.amount-value {
  font-size: 2rem;
  font-weight: 800;
  color: #EF4444;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-top: 1px solid #E5E7EB;
}

.order-time {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.9rem;
  color: #9CA3AF;
}

.order-actions {
  display: flex;
  gap: 12px;
}

.order-actions button {
  padding: 8px 20px;
  border-radius: 8px;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
}

.btn-detail {
  background: #F3F4F6;
  color: #374151;
}

.btn-detail:hover {
  background: #E5E7EB;
}

.btn-cancel {
  background: #FEF2F2;
  color: #DC2626;
}

.btn-cancel:hover {
  background: #FEE2E2;
}

.btn-primary {
  background: #10B981;
  color: white;
}

.btn-primary:hover {
  background: #059669;
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
  margin-bottom: 2rem;
}

.btn-create-order {
  padding: 14px 32px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-create-order:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

/* Responsive */
@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .order-body {
    flex-direction: column;
  }

  .order-amount {
    text-align: left;
  }

  .order-footer {
    flex-direction: column;
    gap: 1rem;
    align-items: flex-start;
  }

  .order-actions {
    width: 100%;
    justify-content: flex-end;
  }
}
</style>
