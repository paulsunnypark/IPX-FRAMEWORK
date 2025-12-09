<template>
    <div class="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 flex items-center justify-center p-4">
        <!-- 배경 그래픽 영역 -->
        <div class="absolute inset-0 overflow-hidden opacity-20">
            <div class="absolute right-0 top-0 w-1/2 h-full flex flex-wrap gap-4 p-8">
                <!-- 통신/기술 아이콘들을 시각적으로 표현 (CSS로 구현) -->
                <div class="w-16 h-16 border-2 border-white/30 rounded-lg"></div>
                <div class="w-12 h-12 border-2 border-white/30 rounded-full"></div>
                <div class="w-20 h-20 border-2 border-white/30 rounded-lg"></div>
                <div class="w-14 h-14 border-2 border-white/30 rounded-full"></div>
                <div class="w-18 h-18 border-2 border-white/30 rounded-lg"></div>
                <div class="w-10 h-10 border-2 border-white/30 rounded-full"></div>
            </div>
        </div>

        <div class="relative z-10 w-full max-w-md">
            <!-- 로고 및 타이틀 -->
            <div class="text-center mb-8">
                <h1 class="text-4xl font-bold text-white mb-2">
                    <span class="text-orange-400">SØLUTECH</span> IPX-VR
                </h1>
                <p class="text-gray-400 text-sm">www.solu.co.kr</p>
                <h2 class="text-3xl font-semibold text-white mt-6 mb-4">Member Login</h2>
                <p class="text-gray-300 text-sm leading-relaxed max-w-md mx-auto">
                    녹취 시스템은 통화 내용을 음성 및 통화 시간과 함께 기록, 저장, 청취할 수 있는 시스템을 제공하여 
                    고객(신고자)과의 분쟁 해결 및 사건 관리를 위한 역할을 합니다.
                </p>
            </div>

            <!-- 로그인 폼 -->
            <Panel class="bg-gray-800/90 backdrop-blur-sm border border-gray-700">
                <template #header>
                    <div class="text-white font-semibold">로그인</div>
                </template>
                
                <form @submit.prevent="handleLogin" class="space-y-4">
                    <div>
                        <label for="userId" class="block text-sm font-medium text-gray-300 mb-2">
                            사용자ID
                        </label>
                        <InputText
                            id="userId"
                            v-model="form.userId"
                            placeholder="사용자ID를 입력하세요"
                            class="w-full"
                            :class="{ 'p-invalid': errors.userId }"
                        />
                        <small v-if="errors.userId" class="p-error">{{ errors.userId }}</small>
                    </div>

                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-300 mb-2">
                            비밀번호
                        </label>
                        <Password
                            id="password"
                            v-model="form.password"
                            placeholder="비밀번호를 입력하세요"
                            class="w-full"
                            :feedback="false"
                            toggleMask
                            :class="{ 'p-invalid': errors.password }"
                        />
                        <small v-if="errors.password" class="p-error">{{ errors.password }}</small>
                    </div>

                    <Button
                        type="submit"
                        label="LOGIN"
                        icon="pi pi-sign-in"
                        class="w-full bg-orange-500 hover:bg-orange-600 border-orange-500"
                        :loading="loading"
                    />
                </form>
            </Panel>

            <!-- 푸터 -->
            <p class="text-center text-gray-500 text-xs mt-8">
                COPYRIGHT 2025 BY SOLUTECH CO,.LTD. ALL RIGHTS RESERVED.
            </p>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import Panel from 'primevue/panel'
import InputText from 'primevue/inputtext'
import Password from 'primevue/password'
import Button from 'primevue/button'
import axios from 'axios'

const router = useRouter()

const form = reactive({
    userId: 'admin',
    password: ''
})

const errors = reactive({
    userId: '',
    password: ''
})

const loading = ref(false)

const validateForm = () => {
    errors.userId = ''
    errors.password = ''

    if (!form.userId.trim()) {
        errors.userId = '사용자ID를 입력해주세요'
        return false
    }

    if (!form.password) {
        errors.password = '비밀번호를 입력해주세요'
        return false
    }

    return true
}

const handleLogin = async () => {
    if (!validateForm()) return

    loading.value = true

    try {
        // TODO: 실제 API 엔드포인트로 변경
        // const response = await axios.post('/api/auth/login', form)
        
        // 임시: 로그인 성공 처리
        setTimeout(() => {
            loading.value = false
            router.push('/inquiry')
        }, 500)
    } catch (error) {
        loading.value = false
        console.error('Login error:', error)
        // 에러 처리
    }
}
</script>

<style scoped>
/* 추가 스타일링이 필요한 경우 */
</style>

