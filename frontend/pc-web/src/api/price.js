/**
 * 价格 API 服务
 * 提供价格查询、趋势数据等接口
 */

const API_BASE = '/api/v1'

/**
 * 获取当前价格列表
 */
export async function getCurrentPrices() {
  const response = await fetch(`${API_BASE}/prices/current`)
  if (!response.ok) {
    throw new Error('获取价格失败')
  }
  return response.json()
}

/**
 * 获取价格趋势数据
 * @param {string} category - 分类（废纸/塑料/金属/玻璃/纺织品）
 * @param {string} timeRange - 时间范围（7d/30d/90d）
 */
export async function getPriceTrend(category, timeRange = '7d') {
  const params = new URLSearchParams({
    category,
    time_range: timeRange
  })
  
  const response = await fetch(`${API_BASE}/prices/trend?${params}`)
  if (!response.ok) {
    throw new Error('获取趋势数据失败')
  }
  return response.json()
}

/**
 * 获取所有分类的价格趋势（用于图表）
 * @param {string} timeRange - 时间范围（7d/30d/90d）
 */
export async function getAllCategoriesTrend(timeRange = '7d') {
  const params = new URLSearchParams({
    time_range: timeRange
  })
  
  const response = await fetch(`${API_BASE}/prices/trend/all?${params}`)
  if (!response.ok) {
    throw new Error('获取趋势数据失败')
  }
  return response.json()
}

/**
 * 获取价格历史（分页）
 * @param {Object} options - 查询选项
 * @param {string} options.category - 分类
 * @param {number} options.page - 页码
 * @param {number} options.pageSize - 每页数量
 */
export async function getPriceHistory(options = {}) {
  const params = new URLSearchParams({
    category: options.category || '',
    page: options.page?.toString() || '1',
    page_size: options.pageSize?.toString() || '20'
  })
  
  const response = await fetch(`${API_BASE}/prices/history?${params}`)
  if (!response.ok) {
    throw new Error('获取历史记录失败')
  }
  return response.json()
}

/**
 * 订阅价格变动通知
 * @param {string} category - 分类
 * @param {number} targetPrice - 目标价格
 * @param {string} phone - 手机号
 */
export async function subscribePriceAlert(category, targetPrice, phone) {
  const response = await fetch(`${API_BASE}/prices/alert`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      category,
      target_price: targetPrice,
      phone
    })
  })
  
  if (!response.ok) {
    throw new Error('订阅失败')
  }
  return response.json()
}

export default {
  getCurrentPrices,
  getPriceTrend,
  getAllCategoriesTrend,
  getPriceHistory,
  subscribePriceAlert
}
