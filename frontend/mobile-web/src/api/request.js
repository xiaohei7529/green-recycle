import axios from 'axios'

const request = axios.create({
  baseURL: '/api/v1',
  timeout: 10000
})

request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

request.interceptors.response.use(
  res => res.data,
  err => {
    if (err.response?.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
      window.location.href = '/login'
    }
    const message = err.response?.data?.message || '请求失败，请稍后重试'
    return Promise.reject(new Error(message))
  }
)

export default request
