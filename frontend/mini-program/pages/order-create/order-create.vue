<template>
  <view class="container">
    <view class="form-card">
      <!-- 回收类型 -->
      <view class="form-section">
        <view class="section-label">回收类型</view>
        <view class="type-row">
          <view
            :class="['type-item', form.type === 1 ? 'active' : '']"
            @click="form.type = 1"
          >
            <text class="type-icon">🚗</text>
            <text>上门回收</text>
          </view>
          <view
            :class="['type-item', form.type === 2 ? 'active' : '']"
            @click="form.type = 2"
          >
            <text class="type-icon">🏪</text>
            <text>站点回收</text>
          </view>
        </view>
      </view>

      <!-- 联系人 -->
      <view class="form-section">
        <view class="section-label">联系信息</view>
        <view class="input-group">
          <text class="input-label">联系人姓名</text>
          <input
            class="input"
            v-model="form.contact_name"
            placeholder="请输入联系人姓名"
          />
        </view>
        <view class="input-group">
          <text class="input-label">联系电话</text>
          <input
            class="input"
            v-model="form.contact_phone"
            type="number"
            maxlength="11"
            placeholder="请输入联系电话"
          />
        </view>
      </view>

      <!-- 地址 -->
      <view class="form-section">
        <view class="section-label">回收地址</view>
        <view class="input-group">
          <textarea
            class="textarea"
            v-model="form.address"
            placeholder="请输入详细地址（如：XX省XX市XX区XX街道XX号）"
            :maxlength="200"
          />
        </view>
      </view>

      <!-- 预约时间 -->
      <view class="form-section">
        <view class="section-label">预约时间</view>
        <view class="picker-row" @click="openDatePicker">
          <text :class="['picker-text', !form.pickup_time ? 'placeholder' : '']">
            {{ form.pickup_time || '请选择预约时间' }}
          </text>
          <text class="picker-arrow">›</text>
        </view>
      </view>

      <!-- 回收物品 -->
      <view class="form-section">
        <view class="section-label">回收物品</view>
        <view class="input-group">
          <text class="input-label">物品描述</text>
          <textarea
            class="textarea"
            v-model="form.item_desc"
            placeholder="请描述要回收的物品（如：旧纸箱约20kg，废铁约5kg）"
            :maxlength="300"
          />
        </view>
      </view>

      <!-- 备注 -->
      <view class="form-section">
        <view class="section-label">备注（选填）</view>
        <textarea
          class="textarea"
          v-model="form.remarks"
          placeholder="如有特殊要求请填写"
          :maxlength="200"
        />
      </view>
    </view>

    <!-- 提交按钮 -->
    <button class="btn-submit" :disabled="submitting" @click="handleSubmit">
      {{ submitting ? '提交中...' : '确认预约' }}
    </button>
  </view>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useAuthStore } from '@/stores/auth'
import { createOrder } from '@/api/orders'

const authStore = useAuthStore()
const submitting = ref(false)

onShow(() => {
  if (!authStore.isLoggedIn) {
    uni.navigateTo({ url: '/pages/login/login' })
  }
})

const form = reactive({
  type: 1,
  contact_name: '',
  contact_phone: '',
  address: '',
  pickup_time: '',
  item_desc: '',
  remarks: ''
})

const openDatePicker = () => {
  uni.showActionSheet({
    itemList: generateTimeSlots(),
    success(res) {
      form.pickup_time = timeSlots[res.tapIndex]
    }
  })
}

const timeSlots = (() => {
  const slots = []
  const now = new Date()
  for (let d = 1; d <= 7; d++) {
    const day = new Date(now)
    day.setDate(now.getDate() + d)
    const dateStr = `${day.getFullYear()}-${String(day.getMonth() + 1).padStart(2, '0')}-${String(day.getDate()).padStart(2, '0')}`
    for (const h of ['09:00', '14:00', '16:00']) {
      slots.push(`${dateStr} ${h}`)
      if (slots.length >= 9) return slots
    }
  }
  return slots
})()

const generateTimeSlots = () => timeSlots.map(s => {
  const d = new Date(s)
  const days = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
  return `${s.slice(5, 10)} ${days[d.getDay()]} ${s.slice(11, 16)}`
})

const handleSubmit = async () => {
  if (!form.contact_name.trim()) {
    uni.showToast({ title: '请输入联系人姓名', icon: 'none' })
    return
  }
  if (!/^1[3-9]\d{9}$/.test(form.contact_phone)) {
    uni.showToast({ title: '请输入正确的联系电话', icon: 'none' })
    return
  }
  if (!form.address.trim()) {
    uni.showToast({ title: '请输入回收地址', icon: 'none' })
    return
  }
  if (!form.pickup_time) {
    uni.showToast({ title: '请选择预约时间', icon: 'none' })
    return
  }
  if (!form.item_desc.trim()) {
    uni.showToast({ title: '请描述回收物品', icon: 'none' })
    return
  }

  submitting.value = true
  try {
    await createOrder({
      type: form.type,
      address: form.address,
      contact_name: form.contact_name,
      contact_phone: form.contact_phone,
      pickup_time: form.pickup_time,
      remarks: (form.item_desc + (form.remarks ? '\n' + form.remarks : '')).trim(),
      items: [{ category_id: 1, estimated_weight: 0 }]
    })
    uni.showToast({ title: '预约成功！', icon: 'success' })
    setTimeout(() => {
      uni.switchTab({ url: '/pages/orders/orders' })
    }, 1200)
  } catch {
    // 错误已在 request.js 内提示
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.container {
  padding: 24rpx 24rpx 40rpx;
  background: #f5f7fa;
  min-height: 100vh;
}

.form-card {
  background: #fff;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06);
  margin-bottom: 30rpx;
}

.form-section {
  padding: 30rpx;
  border-bottom: 1rpx solid #f5f5f5;
}

.form-section:last-child {
  border-bottom: none;
}

.section-label {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.type-row {
  display: flex;
  gap: 20rpx;
}

.type-item {
  flex: 1;
  border: 2rpx solid #e5e7eb;
  border-radius: 14rpx;
  padding: 28rpx 20rpx;
  text-align: center;
  font-size: 28rpx;
  color: #666;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10rpx;
}

.type-item.active {
  border-color: #10B981;
  background: #ecfdf5;
  color: #10B981;
  font-weight: bold;
}

.type-icon {
  font-size: 48rpx;
}

.input-group {
  margin-bottom: 20rpx;
}

.input-group:last-child {
  margin-bottom: 0;
}

.input-label {
  display: block;
  font-size: 26rpx;
  color: #666;
  margin-bottom: 10rpx;
}

.input {
  background: #f5f7fa;
  border-radius: 10rpx;
  padding: 26rpx 24rpx;
  font-size: 28rpx;
  width: 100%;
  box-sizing: border-box;
}

.textarea {
  background: #f5f7fa;
  border-radius: 10rpx;
  padding: 26rpx 24rpx;
  font-size: 28rpx;
  width: 100%;
  box-sizing: border-box;
  min-height: 120rpx;
}

.picker-row {
  background: #f5f7fa;
  border-radius: 10rpx;
  padding: 26rpx 24rpx;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.picker-text {
  font-size: 28rpx;
  color: #333;
}

.picker-text.placeholder {
  color: #bbb;
}

.picker-arrow {
  font-size: 40rpx;
  color: #ccc;
  line-height: 1;
}

.btn-submit {
  width: 100%;
  background: linear-gradient(90deg, #10B981, #059669);
  color: #fff;
  border-radius: 50rpx;
  padding: 34rpx 0;
  font-size: 34rpx;
  font-weight: bold;
  text-align: center;
}

.btn-submit[disabled] {
  opacity: 0.6;
}
</style>
