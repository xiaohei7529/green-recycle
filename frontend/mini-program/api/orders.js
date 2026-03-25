import request from './request'

export const fetchOrders = (params) => request.get('/orders', params)
export const fetchOrderDetail = (id) => request.get(`/orders/${id}`)
export const cancelOrder = (id) => request.put(`/orders/${id}/cancel`)
export const createOrder = (data) => request.post('/orders', data)
