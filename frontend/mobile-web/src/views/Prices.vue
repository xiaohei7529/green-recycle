<template>
  <div class="prices">
    <van-nav-bar title="回收价格" />

    <van-notice-bar
      left-icon="info-o"
      text="价格每日更新，仅供参考，实际以回收员确认为准"
      class="notice"
    />

    <van-loading v-if="loading" class="page-loading" size="40" vertical>加载中...</van-loading>

    <van-collapse v-else v-model="activeNames">
      <van-collapse-item
        v-for="cat in categories"
        :key="cat.name"
        :title="getCategoryTitle(cat.name)"
        :name="cat.name"
      >
        <van-cell
          v-for="item in cat.items"
          :key="item.name"
          :title="item.name"
          :value="`¥${item.price}/${item.unit || 'kg'}`"
          value-class="price-value"
        />
      </van-collapse-item>
    </van-collapse>

    <van-empty v-if="!loading && categories.length === 0" description="暂无价格信息" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { showFailToast } from 'vant'
import { fetchPrices } from '@/api/prices'

const CATEGORY_ICONS = {
  '纸类': '📰', '塑料': '🥤', '金属': '🥫', '电器': '🔌',
  '玻璃': '🫙', '纺织': '👕'
}

const loading = ref(true)
const categories = ref([])
const activeNames = ref([])

const getCategoryTitle = (name) => {
  const icon = CATEGORY_ICONS[name] || '♻️'
  return `${icon} ${name}`
}

const loadPrices = async () => {
  loading.value = true
  try {
    const res = await fetchPrices('all')
    categories.value = res.data?.categories || []
    // 默认展开第一个分类
    if (categories.value.length > 0) {
      activeNames.value = [categories.value[0].name]
    }
  } catch (err) {
    showFailToast(err.message || '获取价格失败')
  } finally {
    loading.value = false
  }
}

onMounted(loadPrices)
</script>

<style scoped>
.prices {
  min-height: 100vh;
  background: #f5f5f5;
}

.notice {
  margin: 8px 0;
}

.page-loading {
  display: flex;
  justify-content: center;
  padding-top: 80px;
}

:deep(.price-value) {
  color: #ee0a24;
  font-weight: bold;
}
</style>
