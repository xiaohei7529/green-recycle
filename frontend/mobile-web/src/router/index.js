import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue'),
    meta: { title: '首页' }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/orders',
    name: 'Orders',
    component: () => import('@/views/Orders.vue'),
    meta: { title: '我的订单', requiresAuth: true }
  },
  {
    path: '/order/create',
    name: 'CreateOrder',
    component: () => import('@/views/CreateOrder.vue'),
    meta: { title: '创建订单', requiresAuth: true }
  },
  {
    path: '/order/:id',
    name: 'OrderDetail',
    component: () => import('@/views/OrderDetail.vue'),
    meta: { title: '订单详情', requiresAuth: true }
  },
  {
    path: '/prices',
    name: 'Prices',
    component: () => import('@/views/Prices.vue'),
    meta: { title: '回收价格' }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('@/views/Profile.vue'),
    meta: { title: '个人中心', requiresAuth: true }
  },
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 })
})

router.beforeEach((to, from, next) => {
  if (to.meta.title) {
    document.title = to.meta.title + ' - Green Recycle'
  }
  if (to.meta.requiresAuth && !localStorage.getItem('token')) {
    next({ name: 'Login', query: { redirect: to.fullPath } })
  } else {
    next()
  }
})

export default router
