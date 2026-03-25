import request from './request'

export function fetchOrders(params = {}) {
  return request.get('/orders', { params })
}

export function fetchOrderDetail(id) {
  return request.get(`/orders/${id}`)
}

export function cancelOrder(id) {
  return request.post(`/orders/${id}/cancel`)
}
