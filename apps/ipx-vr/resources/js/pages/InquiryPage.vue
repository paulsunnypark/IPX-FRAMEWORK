<template>
    <div class="min-h-screen bg-gray-50">
        <!-- 헤더 -->
        <header class="bg-white border-b border-gray-200 shadow-sm">
            <div class="flex items-center justify-between px-6 py-4">
                <div class="flex items-center gap-4">
                    <h1 class="text-xl font-bold text-gray-800">IPX-VR - Comet</h1>
                    <span class="text-sm text-gray-500">localhost / IPX-VR</span>
                </div>
                <div class="flex items-center gap-4">
                    <div class="text-right">
                        <p class="text-sm font-medium text-gray-700">
                            {{ userInfo.name }} ({{ userInfo.role }})님 환영합니다.
                        </p>
                        <p class="text-xs text-gray-500">
                            이전 로그인: {{ userInfo.lastLogin }}
                        </p>
                    </div>
                    <Button icon="pi pi-user" text rounded />
                    <Button icon="pi pi-cog" text rounded />
                </div>
            </div>
        </header>

        <div class="flex h-[calc(100vh-73px)]">
            <!-- 좌측 사이드바 -->
            <aside class="w-64 bg-gray-800 text-white">
                <nav class="p-4 space-y-2">
                    <router-link
                        v-for="item in menuItems"
                        :key="item.path"
                        :to="item.path"
                        class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors"
                        :class="currentPath === item.path 
                            ? 'bg-green-600 text-white' 
                            : 'text-gray-300 hover:bg-gray-700'"
                    >
                        <i :class="item.icon" class="text-lg"></i>
                        <span>{{ item.label }}</span>
                        <i class="pi pi-angle-right ml-auto"></i>
                    </router-link>
                </nav>
            </aside>

            <!-- 메인 컨텐츠 -->
            <main class="flex-1 overflow-auto bg-gray-100">
                <div class="p-6">
                    <!-- 페이지 타이틀 -->
                    <div class="mb-6">
                        <h2 class="text-2xl font-bold text-gray-800 mb-2">조회/청취</h2>
                        <p class="text-gray-600">
                            녹취 자료를 조회/청취 및 정보 관리를 할 수 있습니다.
                        </p>
                    </div>

                    <!-- 탭 네비게이션 -->
                    <div class="flex gap-2 mb-6 border-b border-gray-300">
                        <button
                            v-for="tab in tabs"
                            :key="tab.key"
                            @click="activeTab = tab.key"
                            class="px-4 py-2 font-medium transition-colors"
                            :class="activeTab === tab.key
                                ? 'text-green-600 border-b-2 border-green-600'
                                : 'text-gray-600 hover:text-gray-800'"
                        >
                            {{ tab.label }}
                        </button>
                    </div>

                    <!-- 검색 필터 -->
                    <Panel class="mb-6">
                        <template #header>
                            <div class="font-semibold">검색 조건</div>
                        </template>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">기간</label>
                                <div class="flex gap-2">
                                    <Calendar
                                        v-model="filters.startDate"
                                        placeholder="시작일"
                                        showIcon
                                        dateFormat="yy-mm-dd"
                                        class="flex-1"
                                    />
                                    <Calendar
                                        v-model="filters.endDate"
                                        placeholder="종료일"
                                        showIcon
                                        dateFormat="yy-mm-dd"
                                        class="flex-1"
                                    />
                                </div>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">수신/발신</label>
                                <Dropdown
                                    v-model="filters.callType"
                                    :options="callTypeOptions"
                                    optionLabel="label"
                                    optionValue="value"
                                    placeholder="전체"
                                    class="w-full"
                                />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">고객명</label>
                                <InputText
                                    v-model="filters.customerName"
                                    placeholder="고객명 입력"
                                    class="w-full"
                                />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">사용자명</label>
                                <InputText
                                    v-model="filters.userName"
                                    placeholder="사용자명 입력"
                                    class="w-full"
                                />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">고객번호</label>
                                <InputText
                                    v-model="filters.customerNumber"
                                    placeholder="고객번호 입력"
                                    class="w-full"
                                />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">변환상태</label>
                                <Dropdown
                                    v-model="filters.conversionStatus"
                                    :options="conversionStatusOptions"
                                    optionLabel="label"
                                    optionValue="value"
                                    placeholder="전체"
                                    class="w-full"
                                />
                            </div>
                        </div>

                        <div class="mt-4 flex justify-end">
                            <Button
                                label="검색"
                                icon="pi pi-search"
                                class="bg-yellow-500 hover:bg-yellow-600 border-yellow-500"
                                @click="handleSearch"
                            />
                        </div>
                    </Panel>

                    <!-- 액션 버튼 -->
                    <div class="flex gap-2 mb-4">
                        <Button label="엑셀 다운로드" icon="pi pi-file-excel" severity="success" outlined />
                        <Button label="선택 다운로드" icon="pi pi-download" severity="info" outlined />
                        <Button label="선택 듣기" icon="pi pi-play" severity="warning" outlined />
                        <Button label="삭제" icon="pi pi-trash" severity="danger" outlined />
                    </div>

                    <!-- 데이터 테이블 -->
                    <DataTable
                        :value="recordings"
                        :paginator="true"
                        :rows="15"
                        :loading="loading"
                        tableStyle="min-width: 50rem"
                        class="bg-white"
                        v-model:selection="selectedRecordings"
                    >
                        <Column selectionMode="multiple" headerStyle="width: 3rem"></Column>
                        <Column field="date" header="날짜" sortable>
                            <template #body="{ data }">
                                {{ formatDate(data.date) }}
                            </template>
                        </Column>
                        <Column field="department" header="부서" sortable></Column>
                        <Column field="userId" header="사용자ID" sortable></Column>
                        <Column field="userName" header="사용자명" sortable></Column>
                        <Column field="extension" header="내선번호" sortable></Column>
                        <Column field="customerNumber" header="고객번호" sortable></Column>
                        <Column field="customerName" header="고객명" sortable></Column>
                        <Column field="callType" header="수신/발신" sortable>
                            <template #body="{ data }">
                                <Tag
                                    :value="data.callType"
                                    :severity="data.callType === '수신' ? 'success' : 'info'"
                                />
                            </template>
                        </Column>
                        <Column field="duration" header="녹음시간" sortable></Column>
                        <Column field="downloadCount" header="다운">
                            <template #body="{ data }">
                                <Button
                                    icon="pi pi-download"
                                    text
                                    rounded
                                    severity="secondary"
                                    v-tooltip="`다운로드: ${data.downloadCount}회`"
                                />
                                <span class="ml-1 text-xs text-gray-500">{{ data.downloadCount }}</span>
                            </template>
                        </Column>
                        <Column header="관리" style="width: 200px">
                            <template #body="{ data }">
                                <div class="flex gap-2">
                                    <Button
                                        icon="pi pi-play"
                                        text
                                        rounded
                                        severity="info"
                                        v-tooltip="'듣기'"
                                        @click="handlePlay(data)"
                                    />
                                    <Button
                                        icon="pi pi-comment"
                                        text
                                        rounded
                                        severity="secondary"
                                        v-tooltip="'메모'"
                                        @click="handleMemo(data)"
                                    />
                                    <Button
                                        icon="pi pi-file-edit"
                                        text
                                        rounded
                                        severity="warning"
                                        v-tooltip="'추출'"
                                        @click="handleExtract(data)"
                                    />
                                    <Button
                                        icon="pi pi-pencil"
                                        text
                                        rounded
                                        severity="info"
                                        v-tooltip="'수정'"
                                        @click="handleEdit(data)"
                                    />
                                    <Button
                                        icon="pi pi-trash"
                                        text
                                        rounded
                                        severity="danger"
                                        v-tooltip="'삭제'"
                                        @click="handleDelete(data)"
                                    />
                                </div>
                            </template>
                        </Column>
                    </DataTable>
                </div>
            </main>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import Panel from 'primevue/panel'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import Button from 'primevue/button'
import InputText from 'primevue/inputtext'
import Calendar from 'primevue/calendar'
import Dropdown from 'primevue/dropdown'
import Tag from 'primevue/tag'
// Tooltip은 main.js에서 전역 디렉티브로 등록됨
import axios from 'axios'

const route = useRoute()
const currentPath = route.path

const userInfo = reactive({
    name: 'admin',
    role: '시스템관리자',
    lastLogin: '2025-12-08 10:52:52 [::1]'
})

const menuItems = [
    { path: '/inquiry', label: '조회/청취', icon: 'pi pi-headphones' },
    { path: '/download', label: '다운로드 내역', icon: 'pi pi-download' },
    { path: '/data', label: '데이터관리', icon: 'pi pi-folder' },
    { path: '/notice', label: '고지멘트관리', icon: 'pi pi-megaphone' },
    { path: '/task', label: '작업기록', icon: 'pi pi-clipboard' },
    { path: '/statistics', label: '통계', icon: 'pi pi-chart-bar' },
    { path: '/settings', label: '환경설정', icon: 'pi pi-cog' }
]

const tabs = [
    { key: 'org', label: '조직도' },
    { key: 'list', label: '조회청취 리스트' }
]

const activeTab = ref('list')

const filters = reactive({
    startDate: null,
    endDate: null,
    callType: null,
    customerName: '',
    userName: '',
    customerNumber: '',
    conversionStatus: null
})

const callTypeOptions = [
    { label: '전체', value: null },
    { label: '수신', value: '수신' },
    { label: '발신', value: '발신' }
]

const conversionStatusOptions = [
    { label: '전체', value: null },
    { label: '완료', value: 'completed' },
    { label: '진행중', value: 'processing' },
    { label: '실패', value: 'failed' }
]

const recordings = ref([])
const selectedRecordings = ref([])
const loading = ref(false)

// 임시 데이터 (나중에 API로 대체)
const mockData = [
    {
        id: 1,
        date: '2025-11-16 21:35:58',
        department: '응급실',
        userId: '2201',
        userName: '응급실1_암호화X',
        extension: '2201',
        customerNumber: '01040109705',
        customerName: '',
        callType: '수신',
        duration: '00:02:59',
        downloadCount: 15
    },
    {
        id: 2,
        date: '2024-03-19 09:10:00',
        department: '테스트4',
        userId: 'test02',
        userName: '녹취 테스트4',
        extension: '2003',
        customerNumber: '2002',
        customerName: '고객A',
        callType: '발신',
        duration: '00:05:01',
        downloadCount: 4
    },
    {
        id: 3,
        date: '2024-03-19 09:10:00',
        department: '솔루텍',
        userId: 'test02',
        userName: 'test02',
        extension: '2003',
        customerNumber: '2002',
        customerName: '고객B',
        callType: '발신',
        duration: '00:05:01',
        downloadCount: 3
    }
]

const formatDate = (dateString) => {
    if (!dateString) return ''
    return dateString
}

const handleSearch = () => {
    loading.value = true
    // TODO: API 호출
    setTimeout(() => {
        recordings.value = mockData
        loading.value = false
    }, 500)
}

const handlePlay = (record) => {
    console.log('Play:', record)
    // TODO: 재생 로직
}

const handleMemo = (record) => {
    console.log('Memo:', record)
    // TODO: 메모 로직
}

const handleExtract = (record) => {
    console.log('Extract:', record)
    // TODO: 추출 로직
}

const handleEdit = (record) => {
    console.log('Edit:', record)
    // TODO: 수정 로직
}

const handleDelete = (record) => {
    console.log('Delete:', record)
    // TODO: 삭제 로직
}

onMounted(() => {
    // 초기 데이터 로드
    recordings.value = mockData
})
</script>

