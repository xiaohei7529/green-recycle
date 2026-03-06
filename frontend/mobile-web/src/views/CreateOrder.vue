<template>
  <div class="create-order">
    <van-form @submit="onSubmit">
      <van-cell-group inset title="废品信息">
        <van-field
          v-model="form.type"
          is-link
          readonly
          name="type"
          label="废品类型"
          placeholder="请选择废品类型"
          @click="showTypePicker = true"
        />
        <van-field
          v-model="form.weight"
          type="number"
          name="weight"
          label="预估重量"
          placeholder="请输入重量"
        >
          <template #right>
            <span style="color: #999">kg</span>
          </template>
        </van-field>
      </van-cell-group>

      <van-cell-group inset title="上门信息" style="margin-top: 20px">
        <van-field
          v-model="form.pickupTime"
          is-link
          readonly
          name="pickupTime"
          label="上门时间"
          placeholder="请选择上门时间"
          @click="showTimePicker = true"
        />
        <van-field
          v-model="form.address"
          rows="2"
          autosize
          label="详细地址"
          type="textarea"
          placeholder="请输入详细地址"
        />
        <van-field
          v-model="form.contactName"
          name="contactName"
          label="联系人"
          placeholder="请输入联系人姓名"
        />
        <van-field
          v-model="form.contactPhone"
          type="tel"
          name="contactPhone"
          label="联系电话"
          placeholder="请输入联系电话"
        />
      </van-cell-group>

      <div style="margin: 20px 16px">
        <van-button round block type="primary" native-type="submit">
          立即下单
        </van-button>
      </div>
    </van-form>

    <!-- 类型选择器 -->
    <van-popup v-model:show="showTypePicker" position="bottom">
      <van-picker
        :columns="typeColumns"
        @confirm="onTypeConfirm"
        @cancel="showTypePicker = false"
      />
    </van-popup>

    <!-- 时间选择器 -->
    <van-popup v-model:show="showTimePicker" position="bottom">
      <van-datetime-picker
        v-model="currentTime"
        type="datetime"
        :min-date="minDate"
        :max-date="maxDate"
        @confirm="onTimeConfirm"
        @cancel="showTimePicker = false"
      />
    </van-popup>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  VanForm, VanCellGroup, VanField, VanButton, VanPopup, VanPicker,
  VanDatetimePicker, showToast
} from 'vant'

const router = useRouter()

const form = ref({
  type: '',
  weight: '',
  pickupTime: '',
  address: '',
  contactName: '',
  contactPhone: ''
})

const showTypePicker = ref(false)
const showTimePicker = ref(false)
const currentTime = ref(new Date())

const minDate = new Date()
const maxDate = new Date()
maxDate.setDate(maxDate.getDate() + 7)

const typeColumns = [
  { text: '纸类', value: 'paper' },
  { text: '塑料', value: 'plastic' },
  { text: '金属', value: 'metal' },
  { text: '电器', value: 'electronic' }
]

const onTypeConfirm = ({ selectedOptions }) => {
  form.value.type = selectedOptions[0].text
  showTypePicker.value = false
}

const onTimeConfirm = ({ selectedValues }) => {
  form.value.pickupTime = selectedValues.join('-')
  showTimePicker.value = false
}

const onSubmit = () => {
  if (!form.value.type || !form.value.weight || !form.value.address) {
    showToast('请填写完整信息')
    return
  }
  showToast('下单成功')
  setTimeout(() => {
    router.push('/orders')
  }, 1000)
}
</script>

<style scoped>
.create-order {
  padding: 10px 0;
  background: #f5f5f5;
  min-height: 100vh;
}
</style>
