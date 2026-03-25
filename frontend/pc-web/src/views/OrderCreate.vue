<template>
  <div class="create-order-page">
    <section class="page-header">
      <div class="container">
        <h1>📝 创建回收订单</h1>
        <p>填写回收信息，预约上门回收服务</p>
      </div>
    </section>

    <section class="form-section">
      <div class="container">
        <form class="order-form" @submit.prevent="handleSubmit">
          <!-- 回收类型 -->
          <div class="form-card">
            <h3 class="card-title">📦 回收类型</h3>
            <div class="type-options">
              <label class="type-option" :class="{ active: form.type === 1 }">
                <input type="radio" v-model="form.type" :value="1" />
                <span class="type-icon">🏠</span>
                <span class="type-name">上门回收</span>
                <span class="type-desc">回收员上门取件</span>
              </label>
              <label class="type-option" :class="{ active: form.type === 2 }">
                <input type="radio" v-model="form.type" :value="2" />
                <span class="type-icon">🏪</span>
                <span class="type-name">站点回收</span>
                <span class="type-desc">自行送至回收点</span>
              </label>
            </div>
          </div>

          <!-- 回收物品 -->
          <div class="form-card">
            <h3 class="card-title">♻️ 回收物品</h3>
            <div class="items-list">
              <div class="item-row" v-for="(item, idx) in form.items" :key="idx">
                <select v-model="item.category" class="form-select">
                  <option value="">请选择分类</option>
                  <option value="纸类">纸类</option>
                  <option value="塑料">塑料</option>
                  <option value="金属">金属</option>
                  <option value="电器">电器</option>
                  <option value="纺织">纺织</option>
                </select>
                <input v-model.number="item.weight" type="number" step="0.1" min="0.1" placeholder="重量(kg)" class="form-input-sm" />
                <input v-model.number="item.price" type="number" step="0.1" min="0" placeholder="单价(元)" class="form-input-sm" />
                <button type="button" class="btn-remove" @click="removeItem(idx)" v-if="form.items.length > 1">✕</button>
              </div>
            </div>
            <button type="button" class="btn-add-item" @click="addItem">+ 添加物品</button>
          </div>

          <!-- 上门地址 -->
          <div class="form-card">
            <h3 class="card-title">📍 上门地址</h3>
            <div class="form-grid">
              <input v-model="form.address.province" type="text" placeholder="省份" class="form-input" />
              <input v-model="form.address.city" type="text" placeholder="城市" class="form-input" />
              <input v-model="form.address.district" type="text" placeholder="区/县" class="form-input" />
              <input v-model="form.address.detail" type="text" placeholder="详细地址（街道/小区/门牌号）" class="form-input full-width" />
            </div>
          </div>

          <!-- 联系信息 -->
          <div class="form-card">
            <h3 class="card-title">👤 联系信息</h3>
            <div class="form-grid">
              <input v-model="form.contact.name" type="text" placeholder="联系人姓名" class="form-input" />
              <input v-model="form.contact.phone" type="tel" placeholder="联系电话" maxlength="11" class="form-input" />
            </div>
          </div>

          <!-- 上门时间 -->
          <div class="form-card">
            <h3 class="card-title">⏰ 上门时间</h3>
            <input v-model="form.pickupTime" type="datetime-local" class="form-input" />
          </div>

          <!-- 备注 -->
          <div class="form-card">
            <h3 class="card-title">📝 备注</h3>
            <textarea v-model="form.remark" placeholder="请输入备注信息（选填）" class="form-textarea"></textarea>
          </div>

          <div v-if="errorMsg" class="error-msg">{{ errorMsg }}</div>

          <div class="form-actions">
            <router-link to="/orders" class="btn-cancel-order">取消</router-link>
            <button type="submit" class="btn-submit" :disabled="loading">
              {{ loading ? '提交中...' : '提交订单' }}
            </button>
          </div>
        </form>
      </div>
    </section>
  </div>
</template>

<script>
import request from '@/api/request'

export default {
  name: 'OrderCreatePage',
  data() {
    const now = new Date()
    now.setHours(now.getHours() + 2)
    const pad = n => String(n).padStart(2, '0')
    const defaultTime = `${now.getFullYear()}-${pad(now.getMonth()+1)}-${pad(now.getDate())}T${pad(now.getHours())}:00`

    return {
      loading: false,
      errorMsg: '',
      form: {
        type: 1,
        items: [{ category: '', weight: '', price: '' }],
        address: { province: '', city: '', district: '', detail: '' },
        contact: { name: '', phone: '' },
        pickupTime: defaultTime,
        remark: ''
      }
    }
  },
  methods: {
    addItem() {
      this.form.items.push({ category: '', weight: '', price: '' })
    },
    removeItem(idx) {
      this.form.items.splice(idx, 1)
    },
    async handleSubmit() {
      this.errorMsg = ''

      const validItems = this.form.items.filter(i => i.category && i.weight > 0)
      if (validItems.length === 0) {
        this.errorMsg = '请至少添加一项回收物品'
        return
      }
      if (!this.form.address.detail) {
        this.errorMsg = '请填写详细地址'
        return
      }
      if (!this.form.contact.name || !this.form.contact.phone) {
        this.errorMsg = '请填写联系人信息'
        return
      }

      this.loading = true
      try {
        const pickupTime = this.form.pickupTime.replace('T', ' ') + ':00'
        await request.post('/orders', {
          type: this.form.type,
          items: validItems,
          address: this.form.address,
          contact: this.form.contact,
          pickup_time: pickupTime,
          remark: this.form.remark
        })
        this.$router.push('/orders')
      } catch (err) {
        this.errorMsg = err.message
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.create-order-page {
  min-height: 100vh;
  background: #F9FAFB;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 24px;
}

.page-header {
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  padding: 3rem 0;
  text-align: center;
}

.page-header h1 {
  font-size: 2rem;
  font-weight: 800;
  margin-bottom: 0.5rem;
}

.page-header p {
  font-size: 1rem;
  opacity: 0.9;
}

.form-section {
  padding: 2rem 0 4rem;
}

.order-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-card {
  background: white;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.card-title {
  font-size: 1.1rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 1.25rem;
}

.type-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.type-option {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 1.5rem;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
}

.type-option input[type="radio"] { display: none; }

.type-option.active {
  border-color: #10B981;
  background: #ECFDF5;
}

.type-icon { font-size: 2rem; }

.type-name {
  font-weight: 600;
  color: #111827;
}

.type-desc {
  font-size: 0.85rem;
  color: #6B7280;
}

.items-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.item-row {
  display: flex;
  gap: 0.75rem;
  align-items: center;
}

.form-select, .form-input, .form-input-sm {
  padding: 12px 14px;
  border: 2px solid #E5E7EB;
  border-radius: 10px;
  font-size: 0.95rem;
  outline: none;
  transition: border-color 0.2s;
}

.form-select:focus, .form-input:focus, .form-input-sm:focus {
  border-color: #10B981;
}

.form-select { flex: 2; }
.form-input-sm { flex: 1; min-width: 0; }
.form-input { width: 100%; box-sizing: border-box; }
.form-input.full-width { grid-column: 1 / -1; }

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.75rem;
}

.btn-remove {
  padding: 8px 12px;
  background: #FEF2F2;
  color: #DC2626;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.85rem;
}

.btn-add-item {
  padding: 10px 20px;
  background: #ECFDF5;
  color: #10B981;
  border: 2px dashed #10B981;
  border-radius: 10px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  width: 100%;
  transition: all 0.2s;
}

.btn-add-item:hover { background: #D1FAE5; }

.form-textarea {
  width: 100%;
  min-height: 100px;
  padding: 12px 14px;
  border: 2px solid #E5E7EB;
  border-radius: 10px;
  font-size: 0.95rem;
  resize: vertical;
  outline: none;
  box-sizing: border-box;
}

.form-textarea:focus { border-color: #10B981; }

.error-msg {
  padding: 12px 16px;
  background: #FEF2F2;
  border: 1px solid #FECACA;
  border-radius: 10px;
  color: #DC2626;
  font-size: 0.9rem;
}

.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
}

.btn-cancel-order {
  padding: 14px 32px;
  background: white;
  color: #6B7280;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  transition: all 0.2s;
}

.btn-cancel-order:hover { border-color: #D1D5DB; background: #F9FAFB; }

.btn-submit {
  padding: 14px 40px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
}

.btn-submit:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

.btn-submit:disabled { opacity: 0.7; cursor: not-allowed; }

@media (max-width: 768px) {
  .type-options { grid-template-columns: 1fr; }
  .form-grid { grid-template-columns: 1fr; }
  .item-row { flex-wrap: wrap; }
}
</style>
