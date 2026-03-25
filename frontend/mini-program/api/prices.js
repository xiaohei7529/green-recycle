import request from './request'

export const fetchPrices = () => request.get('/prices')
