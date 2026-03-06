<template>
  <div class="prices">
    <van-notice-bar
      left-icon="info-o"
      text="价格每日更新，仅供参考"
      class="notice"
    />

    <van-collapse v-model="activeNames">
      <van-collapse-item title="📰 纸类" name="1">
        <van-cell
          v-for="item in prices.paper"
          :key="item.name"
          :title="item.name"
          :value="`¥${item.price}/${item.unit}`"
          value-class="price-value"
        />
      </van-collapse-item>
      <van-collapse-item title="🥤 塑料" name="2">
        <van-cell
          v-for="item in prices.plastic"
          :key="item.name"
          :title="item.name"
          :value="`¥${item.price}/${item.unit}`"
          value-class="price-value"
        />
      </van-collapse-item>
      <van-collapse-item title="🥫 金属" name="3">
        <van-cell
          v-for="item in prices.metal"
          :key="item.name"
          :title="item.name"
          :value="`¥${item.price}/${item.unit}`"
          value-class="price-value"
        />
      </van-collapse-item>
      <van-collapse-item title="🔌 电器" name="4">
        <van-cell
          v-for="item in prices.electronic"
          :key="item.name"
          :title="item.name"
          :value="`¥${item.price}/${item.unit}`"
          value-class="price-value"
        />
      </van-collapse-item>
    </van-collapse>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { VanNoticeBar, VanCollapse, VanCollapseItem, VanCell } from 'vant'

const activeNames = ref(['1'])

const prices = ref({
  paper: [
    { name: '报纸', price: 1.5, unit: 'kg' },
    { name: '纸箱', price: 1.2, unit: 'kg' },
    { name: '书本', price: 1.8, unit: 'kg' }
  ],
  plastic: [
    { name: 'PET 瓶', price: 2.0, unit: 'kg' },
    { name: 'PE 膜', price: 3.5, unit: 'kg' }
  ],
  metal: [
    { name: '铁', price: 3.5, unit: 'kg' },
    { name: '铝', price: 12.0, unit: 'kg' },
    { name: '铜', price: 45.0, unit: 'kg' }
  ],
  electronic: [
    { name: '空调', price: 150.0, unit: '台' },
    { name: '冰箱', price: 100.0, unit: '台' }
  ]
})
</script>

<style scoped>
.prices {
  padding: 10px;
}

.notice {
  margin-bottom: 10px;
}

.price-value {
  color: #f56c6c;
  font-weight: bold;
}
</style>
