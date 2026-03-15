/**
 * 订单 API 服务
 * 提供订单 CRUD、状态查询等接口
 */

const API_BASE = '/api/v1'

/**
 * 获取订单列表
 * @param {Object} options - 查询选项
 * @param {string} options.status - 状态（0/1/2/3/4 或 all）
 * @param {string} options.timeRange - 时间范围（7/30/90 或 all）
 * @param {string} options.search - 搜索关键词
 * @param {number} options.page - 页码
 * @param {number} options.pageSize - 每页数量
 */
export async function getOrders(options = {}) {
  const params = new URLSearchParams({
    status: options.status !== 'all' ? options.status : undefined,
    time_range: options.timeRange !== 'all' ? options.timeRange : undefined,
    search: options.search || undefined,
    page: options.page?.toString() || '1',
    page_size: options.pageSize?.toString() || '20'
  })
  
  const response = await fetch(`${API_BASE}/orders?${params}`, {
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    }
  })
  
  if (!response.ok) {
    throw new Error('获取订单列表失败')
  }
  return response.json()
}

/**
 * 获取订单详情
 * @param {number} orderId - 订单 ID
 */
export async function getOrder(orderId) {
  const response = await fetch(`${API_BASE}/orders/${orderId}`, {
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    }
  })
  
  if (!response.ok) {
    throw new Error('获取订单详情失败')
  }
  return response.json()
}

/**
 * 创建订单
 * @param {Object} orderData - 订单数据
 */
export async function createOrder(orderData) {
  const response = await fetch(`${API_BASE}/orders`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    },
    body: JSON.stringify(orderData)
  })
  
  if (!response.ok) {
    const error = await response.json()
    throw new Error(error.message || '创建订单失败')
  }
  return response.json()
}

/**
 * 取消订单
 * @param {number} orderId - 订单 ID
 */
export async function cancelOrder(orderId) {
  const response = await fetch(`${API_BASE}/orders/${orderId}/cancel`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    }
  })
  
  if (!response.ok) {
    throw new Error('取消订单失败')
  }
  return response.json()
}

/**
 * 评价订单
 * @param {number} orderId - 订单 ID
 * @param {Object} reviewData - 评价数据
 * @param {number} reviewData.rating - 评分（1-5）
 * @param {string} reviewData.comment - 评价内容
 */
export async function reviewOrder(orderId, reviewData) {
  const response = await fetch(`${API_BASE}/orders/${orderId}/review`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    },
    body: JSON.stringify(reviewData)
  })
  
  if (!response.ok) {
    throw new Error('评价失败')
  }
  return response.json()
}

/**
 * 导出订单
 * @param {number} orderId - 订单 ID
 */
export async function exportOrder(orderId) {
  const response = await fetch(`${API_BASE}/orders/${orderId}/export`, {
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    }
  })
  
  if (!response.ok) {
    throw new Error('导出失败')
  }
  return response.blob()
}

/**
 * 批量导出订单
 * @param {Array<number>} orderIds - 订单 ID 列表
 */
export async function batchExportOrders(orderIds) {
  const response = await fetch(`${API_BASE}/orders/export/batch`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    },
    body: JSON.stringify({ order_ids: orderIds })
  })
  
  if (!response.ok) {
    throw new Error('批量导出失败')
  }
  return response.blob()
}

export default {
  getOrders,
  getOrder,
  createOrder,
  cancelOrder,
  reviewOrder,
  exportOrder,
  batchExportOrders
}
