const BASE_URL = 'http://localhost:8080/api'

const request = ({ url, method = 'GET', data = {} }) => {
  return new Promise((resolve, reject) => {
    const token = uni.getStorageSync('token')
    uni.request({
      url: BASE_URL + url,
      method,
      data,
      header: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {})
      },
      success(res) {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(res.data)
        } else if (res.statusCode === 401) {
          uni.removeStorageSync('token')
          uni.removeStorageSync('userInfo')
          uni.reLaunch({ url: '/pages/login/login' })
          reject(new Error('登录已过期，请重新登录'))
        } else {
          const msg = res.data?.message || res.data?.error || `请求失败 (${res.statusCode})`
          uni.showToast({ title: msg, icon: 'none' })
          reject(new Error(msg))
        }
      },
      fail(err) {
        const msg = err.errMsg || '网络请求失败，请检查连接'
        uni.showToast({ title: msg, icon: 'none' })
        reject(new Error(msg))
      }
    })
  })
}

export default {
  get: (url, data) => request({ url, method: 'GET', data }),
  post: (url, data) => request({ url, method: 'POST', data }),
  put: (url, data) => request({ url, method: 'PUT', data }),
  delete: (url, data) => request({ url, method: 'DELETE', data })
}
