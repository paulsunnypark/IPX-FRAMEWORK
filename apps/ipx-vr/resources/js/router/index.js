import { createRouter, createWebHistory } from 'vue-router'
import LoginPage from '../pages/LoginPage.vue'
import InquiryPage from '../pages/InquiryPage.vue'

const routes = [
    {
        path: '/',
        name: 'login',
        component: LoginPage,
        meta: { requiresAuth: false }
    },
    {
        path: '/inquiry',
        name: 'inquiry',
        component: InquiryPage,
        meta: { requiresAuth: true }
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

// 인증 가드 (나중에 구현)
router.beforeEach((to, from, next) => {
    // 임시로 모든 경로 허용
    next()
})

export default router

