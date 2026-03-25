import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(uni.getStorageSync('token') || '')
  const userInfo = ref((() => {
    try {
      const stored = uni.getStorageSync('userInfo')
      return stored ? JSON.parse(stored) : null
    } catch {
      return null
    }
  })())

  const isLoggedIn = computed(() => !!token.value)

  const setAuth = (newToken, newUserInfo) => {
    token.value = newToken
    userInfo.value = newUserInfo
    uni.setStorageSync('token', newToken)
    uni.setStorageSync('userInfo', JSON.stringify(newUserInfo))
  }

  const logout = () => {
    token.value = ''
    userInfo.value = null
    uni.removeStorageSync('token')
    uni.removeStorageSync('userInfo')
  }

  return { token, userInfo, isLoggedIn, setAuth, logout }
})
