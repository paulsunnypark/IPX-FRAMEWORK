import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { VueQueryPlugin, QueryClient } from '@tanstack/vue-query'
import PrimeVue from 'primevue/config'
import Tooltip from 'primevue/tooltip'
import 'primeicons/primeicons.css'
import 'primevue/resources/themes/aura-light-green/theme.css'
import 'primevue/resources/primevue.min.css'
import './bootstrap'
import App from './App.vue'
import router from './router'
import '../css/app.css'

const app = createApp(App)

// Pinia (상태 관리)
app.use(createPinia())

// Vue Router
app.use(router)

// TanStack Query (서버 상태 관리)
const queryClient = new QueryClient({
    defaultOptions: {
        queries: {
            refetchOnWindowFocus: false,
            retry: 1,
        },
    },
})
app.use(VueQueryPlugin, { queryClient })

// PrimeVue 설정 (PrimeVue 3.x)
app.use(PrimeVue)

// PrimeVue 디렉티브
app.directive('tooltip', Tooltip)

app.mount('#app')

