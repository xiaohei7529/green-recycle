import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '@/views/Dashboard.vue'

const routes = [
  {
    path: '/',
    name: 'Dashboard',
    component: Dashboard,
    meta: { title: '数据看板' }
  },
  {
    path: '/users',
    name: 'Users',
    component: () => import('@/views/Users.vue'),
    meta: { title: '用户管理' }
  },
  {
    path: '/recyclers',
    name: 'Recyclers',
    component: () => import('@/views/Recyclers.vue'),
    meta: { title: '回收员管理' }
  },
  {
    path: '/orders',
    name: 'Orders',
    component: () => import('@/views/Orders.vue'),
    meta: { title: '订单管理' }
  },
  {
    path: '/prices',
    name: 'Prices',
    component: () => import('@/views/Prices.vue'),
    meta: { title: '价格管理' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  if (to.meta.title) {
    document.title = to.meta.title + ' - Green Recycle 管理后台'
  }
  next()
})

export default router
