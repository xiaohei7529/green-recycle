import request from './request'

export function fetchPrices(category = 'all') {
  return request.get('/prices', { params: { category } })
}
