# IPX-Framework 아키텍처 개요

## Laravel의 주요 용도

Laravel은 **백엔드 API 서버**로 사용됩니다. 주요 역할은 다음과 같습니다:

### 1. RESTful API 제공
- **API First 전략**: 화면(View)을 리턴하지 않고 **데이터(JSON)만 교환**
- API 경로: `http://localhost:8890/api/*`
- 예시: `GET /api/users`, `POST /api/recordings`, `GET /api/analyses`

### 2. 비즈니스 로직 처리
- **Service Layer**: 비즈니스 로직을 Service 클래스에 구현
  - `SttService.php`: STT 엔진 연동
  - `AnalysisService.php`: LLM 프롬프트 및 분석
  - `StatService.php`: 통계 계산
- **Controller**: 가볍게 유지 (요청 수신 → Service 호출 → JSON 응답)

### 3. 비동기 작업 관리
- **Redis Queue**: AI 분석, STT 변환 등 장시간 작업을 백그라운드로 처리
- **Jobs**: `ProcessSttJob`, `AnalyzeTalkJob` 등
- **Worker**: 백그라운드 프로세스가 Queue에서 작업을 꺼내 실행

### 4. 데이터베이스 관리
- **Eloquent ORM**: 데이터베이스 접근 및 관계 관리
- **Multi-Database**: `ipx_master` (인증/권한), `ipx_vr` (녹취/AI)

### 5. 인증 및 권한 관리
- **Laravel Sanctum**: Vue.js SPA와의 토큰 기반 인증
- **Spatie Laravel Permission**: 복잡한 권한(Role) 관리

## 프론트엔드 (Vue.js)의 역할

Vue.js는 **프론트엔드 SPA (Single Page Application)**로 사용됩니다:

- **사용자 인터페이스**: 모든 UI 컴포넌트
- **API 호출**: Axios를 통해 Laravel API 호출
- **상태 관리**: Pinia를 통한 전역 상태 관리
- **라우팅**: Vue Router를 통한 클라이언트 사이드 라우팅

## 포트 구성 및 요청 흐름

### 현재 포트 구성

```
http://localhost:8890
├── /                    → Vue.js SPA (프론트엔드 UI)
├── /api/*              → Laravel API (백엔드)
├── /build/*            → Vite 빌드된 정적 파일 (CSS, JS)
└── /storage/*          → 업로드된 파일
```

### 요청 흐름

```
1. 사용자가 브라우저에서 http://localhost:8890 접속
   ↓
2. Nginx가 요청을 받음
   ↓
3. 정적 파일 요청 (CSS, JS, 이미지)
   → Nginx가 직접 처리 (public/build/)
   ↓
4. API 요청 (/api/*)
   → Nginx가 PHP-FPM으로 전달
   → Laravel이 JSON 응답 반환
   ↓
5. Vue.js SPA 요청 (/)
   → Nginx가 public/index.html 반환
   → Vue.js가 클라이언트 사이드에서 라우팅 처리
   → Vue.js가 Axios로 API 호출
```

## 개발 모드 vs 프로덕션 모드

### 개발 모드 (npm run dev)
- **Vite 개발 서버**: 별도 포트(8890)에서 실행
- **HMR (Hot Module Replacement)**: 코드 변경 시 자동 새로고침
- **Laravel API**: 여전히 8890 포트의 `/api/*` 경로 사용

### 프로덕션 모드 (npm run build)
- **Vite 빌드**: `public/build/`에 정적 파일 생성
- **Nginx**: 빌드된 파일과 Laravel API를 모두 8890 포트에서 서비스
- **SPA 라우팅**: Nginx가 모든 요청을 `public/index.php`로 전달

## 현재 상태

### ✅ 완료된 것
- Laravel 11 설치 및 설정
- Nginx 포트 8890 설정
- Multi-Database 연결
- 기본 마이그레이션

### ⚠️ 아직 개발되지 않은 것
- **Vue.js 프론트엔드**: 아직 개발되지 않아 Laravel 기본 페이지가 표시됨
- **API 엔드포인트**: 아직 구현되지 않음
- **Service Layer**: 비즈니스 로직 클래스 미구현

## 다음 단계

1. **Vue.js 프론트엔드 개발**
   ```bash
   npm install
   npm run dev
   ```
   - `resources/js/app.js`에 Vue.js 앱 구성
   - `resources/js/components/`에 컴포넌트 생성

2. **Laravel API 개발**
   - `routes/api.php`에 API 라우트 정의
   - `app/Http/Controllers/Api/`에 API 컨트롤러 생성
   - `app/Services/`에 비즈니스 로직 구현

3. **프론트엔드-백엔드 연동**
   - Vue.js에서 Axios로 API 호출
   - 인증 토큰 관리 (Sanctum)

## 참고

- **Laravel 기본 페이지**: 프론트엔드가 개발되지 않아 표시되는 임시 페이지
- **8890 포트**: 프론트엔드 UI와 백엔드 API가 모두 같은 포트에서 서비스됨
- **API 경로**: `/api/*`로 시작하는 모든 요청은 Laravel이 처리

