<template>
  <div class="create-order">
    <van-nav-bar
      title="创建订单"
      left-arrow
      @click-left="router.back()"
    />

    <van-form @submit="onSubmit">
      <van-cell-group inset title="废品信息" class="form-group">
        <van-field
          v-model="form.typeLabel"
          is-link
          readonly
          label="废品类型"
          placeholder="请选择废品类型"
          :rules="[{ required: true, message: '请选择废品类型' }]"
          @click="showTypePicker = true"
        />
        <van-field
          v-model="form.weight"
          type="number"
          label="预估重量"
          placeholder="请输入重量（kg）"
          :rules="[{ required: true, message: '请填写重量' }]"
        />
      </van-cell-group>

      <van-cell-group inset title="上门信息" class="form-group">
        <van-field
          v-model="form.pickupTimeDisplay"
          is-link
          readonly
          label="上门时间"
          placeholder="请选择上门时间"
          :rules="[{ required: true, message: '请选择上门时间' }]"
          @click="showTimePicker = true"
        />
        <van-field
          v-model="form.address"
          rows="2"
          autosize
          label="详细地址"
          type="textarea"
          placeholder="请输入省市区及详细地址"
          :rules="[{ required: true, message: '请填写地址' }]"
        />
        <van-field
          v-model="form.contactName"
          label="联系人"
          placeholder="请输入联系人姓名"
          :rules="[{ required: true, message: '请填写联系人' }]"
        />
        <van-field
          v-model="form.contactPhone"
          type="tel"
          label="联系电话"
          placeholder="请输入联系电话"
          :rules="[{ pattern: /^1\d{10}$/, message: '请输入正确的手机号' }]"
        />
        <van-field v-model="form.remark" label="备注" placeholder="选填" />
      </van-cell-group>

      <div class="submit-area">
        <van-button
          round
          block
          type="primary"
          native-type="submit"
          :loading="submitting"
          loading-text="提交中..."
          class="submit-btn"
        >
          立即下单
        </van-button>
      </div>
    </van-form>

    <!-- 废品类型选择器 -->
    <van-popup v-model:show="showTypePicker" position="bottom" round>
      <van-picker
        :columns="typeColumns"
        @confirm="onTypeConfirm"
        @cancel="showTypePicker = false"
      />
    </van-popup>

    <!-- 上门时间选择器（van-picker-group 替代已移除的 van-datetime-picker） -->
    <van-popup v-model:show="showTimePicker" position="bottom" round>
      <van-picker-group
        title="选择上门时间"
        :tabs="['选择日期', '选择时间']"
        @confirm="onTimeConfirm"
        @cancel="showTimePicker = false"
      >
        <van-date-picker
          v-model="selectedDate"
          :min-date="minDate"
          :max-date="maxDate"
        />
        <van-time-picker
          v-model="selectedTime"
          :min-hour="8"
          :max-hour="20"
        />
      </van-picker-group>
    </van-popup>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { showToast, showFailToast } from 'vant'
import { createOrder } from '@/api/orders'

const router = useRouter()

const form = ref({
  typeLabel: '',
  typeValue: '',
  weight: '',
  pickupTimeDisplay: '',
  pickupTime: '',
  address: '',
  contactName: '',
  contactPhone: '',
  remark: ''
})

const submitting = ref(false)
const showTypePicker = ref(false)
const showTimePicker = ref(false)

// 初始化日期时间为明天上午 10 点
const tomorrow = new Date()
tomorrow.setDate(tomorrow.getDate() + 1)
const pad = n => String(n).padStart(2, '0')

const selectedDate = ref([
  String(tomorrow.getFullYear()),
  pad(tomorrow.getMonth() + 1),
  pad(tomorrow.getDate())
])
const selectedTime = ref(['10', '00'])

const minDate = new Date()
const maxDate = new Date()
maxDate.setDate(maxDate.getDate() + 7)

const typeColumns = [
  { text: '纸类', value: 'paper' },
  { text: '塑料', value: 'plastic' },
  { text: '金属', value: 'metal' },
  { text: '电器', value: 'electronic' },
  { text: '纺织', value: 'textile' }
]

const onTypeConfirm = ({ selectedOptions }) => {
  form.value.typeLabel = selectedOptions[0].text
  form.value.typeValue = selectedOptions[0].value
  showTypePicker.value = false
}

const onTimeConfirm = () => {
  const dateStr = selectedDate.value.join('-')
  const timeStr = selectedTime.value.slice(0, 2).join(':') + ':00'
  form.value.pickupTime = `${dateStr} ${timeStr}`
  form.value.pickupTimeDisplay = `${dateStr} ${selectedTime.value.slice(0, 2).join(':')}`
  showTimePicker.value = false
}

const onSubmit = async () => {
  submitting.value = true
  try {
    await createOrder({
      type: 1,
      items: [{
        category: form.value.typeLabel,
        weight: parseFloat(form.value.weight),
        price: 0
      }],
      address: {
        province: '',
        city: '',
        district: '',
        detail: form.value.address
      },
      contact: {
        name: form.value.contactName,
        phone: form.value.contactPhone
      },
      pickup_time: form.value.pickupTime,
      remark: form.value.remark
    })
    showToast({ message: '下单成功！', type: 'success' })
    setTimeout(() => router.push('/orders'), 1000)
  } catch (err) {
    showFailToast(err.message || '下单失败')
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.create-order {
  min-height: 100vh;
  background: #f5f5f5;
}

.form-group {
  margin-top: 12px;
}

.submit-area {
  margin: 24px 16px;
}

.submit-btn {
  --van-button-primary-background: #10B981;
  --van-button-primary-border-color: #10B981;
  height: 48px;
  font-size: 16px;
}
</style>
