# 프론트엔드 개발 가이드

## 기술 스택

- **Vue.js 3.x**: Composition API (`<script setup>`)
- **PrimeVue 3.x**: 엔터프라이즈급 UI 컴포넌트 라이브러리
- **Tailwind CSS**: 유틸리티 우선 CSS 프레임워크
- **Vue Router 4**: 클라이언트 사이드 라우팅
- **Pinia 2.x**: 상태 관리
- **TanStack Query (Vue Query)**: 서버 상태 관리 및 캐싱
- **Vite**: 빌드 도구 및 개발 서버

## 프로젝트 구조

```
resources/
├── js/
│   ├── main.js              # Vue 앱 진입점
│   ├── App.vue              # 루트 컴포넌트
│   ├── router/
│   │   └── index.js         # 라우터 설정
│   ├── pages/               # 페이지 컴포넌트
│   │   ├── LoginPage.vue    # 로그인 페이지
│   │   └── InquiryPage.vue  # 조회/청취 메인 페이지
│   ├── components/         # 재사용 가능한 컴포넌트
│   ├── stores/              # Pinia 스토어
│   ├── composables/         # Composable 함수
│   └── bootstrap.js         # Axios 설정
└── css/
    └── app.css              # Tailwind CSS 진입점
```

## 개발 워크플로우

### 1. 개발 서버 실행

```bash
npm run dev
```

개발 서버가 `http://localhost:8890`에서 실행됩니다.

### 2. PrimeVue 컴포넌트 사용

PrimeVue 컴포넌트는 개별 import 방식으로 사용합니다:

```vue
<script setup>
import Button from 'primevue/button'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
</script>

<template>
    <Button label="클릭" />
    <DataTable :value="data">
        <Column field="name" header="이름" />
    </DataTable>
</template>
```

### 3. API 호출 (TanStack Query)

```vue
<script setup>
import { useQuery } from '@tanstack/vue-query'
import axios from 'axios'

const { data, isLoading, error } = useQuery({
    queryKey: ['recordings'],
    queryFn: async () => {
        const response = await axios.get('/api/recordings')
        return response.data
    }
})
</script>
```

### 4. 상태 관리 (Pinia)

```javascript
// stores/useAuthStore.js
import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        token: null
    }),
    actions: {
        async login(credentials) {
            // 로그인 로직
        }
    }
})
```

## 주요 화면 구성

### 1. 로그인 페이지 (`/`)
- PrimeVue `Panel`, `InputText`, `Password`, `Button` 사용
- Tailwind CSS로 다크 그라데이션 배경
- 기존 IPX-VR 로그인 화면 참고

### 2. 조회/청취 페이지 (`/inquiry`)
- 좌측 사이드바: 메뉴 네비게이션
- 중앙: 검색 필터 + 데이터 테이블
- PrimeVue `DataTable` 사용
- 필터: `Calendar`, `Dropdown`, `InputText`
- 액션 버튼: 다운로드, 재생, 삭제 등

## 스타일링 가이드

### Tailwind CSS 사용
```vue
<template>
    <div class="p-6 bg-gray-50 min-h-screen">
        <div class="card bg-white rounded-lg shadow-sm">
            <!-- 내용 -->
        </div>
    </div>
</template>
```

### PrimeVue 테마 커스터마이징
`main.js`에서 PrimeVue 테마 설정:
```javascript
app.use(PrimeVue, {
    theme: {
        preset: Aura,
        options: {
            darkModeSelector: false,
        }
    }
})
```

## API 연동

### Axios 설정
`resources/js/bootstrap.js`에서 기본 설정:
```javascript
import axios from 'axios'
window.axios = axios
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
```

### API 호출 예시
```javascript
// GET 요청
const response = await axios.get('/api/recordings', {
    params: { page: 1, limit: 15 }
})

// POST 요청
const response = await axios.post('/api/auth/login', {
    userId: 'admin',
    password: 'password'
})
```

## 다음 단계

1. **녹취 상세 화면 개발**
   - 음성텍스트, 텍스트, 요약, 구분, 키워드, 감성분석 탭
   - 대화 내용 표시 (채팅 형식)

2. **API 엔드포인트 개발**
   - Laravel 백엔드에서 API 구현
   - 인증 (Sanctum)
   - 녹취 목록 조회
   - 녹취 상세 조회

3. **상태 관리 구현**
   - 인증 상태 (Pinia Store)
   - 사용자 정보
   - 녹취 데이터 캐싱

4. **추가 기능**
   - 실시간 업데이트 (WebSocket 또는 Polling)
   - 파일 다운로드
   - 음성 재생 플레이어

## 참고 문서

- [PrimeVue 문서](https://primevue.org/)
- [Vue 3 문서](https://vuejs.org/)
- [TanStack Query 문서](https://tanstack.com/query/latest)
- [Tailwind CSS 문서](https://tailwindcss.com/)

