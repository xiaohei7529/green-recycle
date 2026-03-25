import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || null)
  const userInfo = ref(JSON.parse(localStorage.getItem('userInfo') || 'null'))

  const isLoggedIn = computed(() => !!token.value)

  function setAuth(newToken, info) {
    token.value = newToken
    localStorage.setItem('token', newToken)
    if (info) {
      userInfo.value = info
      localStorage.setItem('userInfo', JSON.stringify(info))
    }
  }

  function logout() {
    token.value = null
    userInfo.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
  }

  return { token, userInfo, isLoggedIn, setAuth, logout }
})
