# IPX-Framework

AI 융합형 통신 솔루션을 위한 차세대 고성능 아키텍처 프레임워크

## 개요

IPX-Framework는 기존 레거시 시스템의 한계(동기식 처리, 스파게티 코드)를 극복하고, **대용량 트래픽(통신)**과 **장시간 프로세스(AI 분석)**를 안정적으로 처리하기 위해 설계된 엔터프라이즈급 프레임워크입니다.

## Tech Stack

- **Web Server**: Nginx 1.25+ (Event-Driven)
- **Backend**: PHP 8.4+ (FPM Mode, JIT 활성화)
- **Framework**: Laravel 11.x
- **Frontend**: Vue.js 3.x (Composition API) + TypeScript
- **State Management**: Pinia 2.x
- **Database**: MariaDB 10.11+ (Multi-Database: ipx_master, ipx_vr)
- **Cache/Queue**: Redis 7.x
- **Build Tool**: Vite

## 현재 상태

### ✅ 완료된 작업
- Docker 환경 구성 (Nginx, PHP-FPM, MariaDB, Redis)
- Windows Docker 환경 최적화 (Named Volume 사용)
- Laravel 11 설치 및 설정 완료
- Multi-Database 구조 설정 (ipx_master, ipx_vr)
- 프론트엔드 개발 환경 구축 (Vue 3 + PrimeVue + Tailwind CSS)
- 로그인 페이지 및 조회/청취 페이지 개발 완료
- 브라우저 테스트 완료 (`http://localhost:8890`)
- **Monorepo 구조 전환 완료** (`apps/ipx-vr/`)

### ⚠️ 다음 작업
- 데모 데이터 통합 (Phase 1)
- Laravel API 엔드포인트 개발
- 인증 시스템 구현

**최신 변경 사항**: Vite/Tailwind 설정 완료, 프론트엔드 정상 작동 확인 (2024-12-09)

**상세 현황**: [`/docs/system/project-status.md`](docs/system/project-status.md)

## 프로젝트 구조

```
/ipx-framework
├── apps/
│   └── ipx-vr/            # VR 애플리케이션 (Laravel)
│       ├── app/            # Backend Core
│       │   ├── Http/
│       │   ├── Models/
│       │   ├── Services/
│       │   ├── Jobs/
│       │   └── Events/
│       ├── resources/js/   # Frontend (Vue.js 3)
│       ├── public/         # 웹 루트
│       └── ...
├── docker/                 # Infrastructure as Code
│   ├── nginx/
│   ├── php/
│   └── mariadb/
├── tasks/                  # 작업과제 (개발 관리)
│   ├── prd-*.md
│   ├── tasks-prd-*.md
│   └── context-contraction.md
├── docs/                   # 산출물 문서
│   ├── user-manual/
│   ├── system/
│   ├── api/
│   └── reports/
└── guide/                  # 개발 가이드
```

### 디렉토리 설명
- **`/tasks`**: 작업과제 및 개발 관리 문서 (PRD, 작업 계획, 컨텍스트 로그)
- **`/docs`**: 산출물 문서 (사용자 메뉴얼, 시스템 구성도, 보고서)
- **`/guide`**: 개발 방법론 및 프레임워크 가이드

## 빠른 시작

### 1. Docker 환경 실행

```bash
docker-compose up -d
```

### 2. Laravel 의존성 설치

```bash
docker-compose exec php composer install
```

### 3. 애플리케이션 키 생성

```bash
docker-compose exec php php artisan key:generate
```

### 4. 데이터베이스 마이그레이션

```bash
# Master DB 마이그레이션
docker-compose exec php php artisan migrate --database=mysql_master

# VR DB 마이그레이션
docker-compose exec php php artisan migrate --database=mysql_vr
```

### 5. 접속 확인

- **프론트엔드**: `http://localhost:8890` (Vue.js SPA)
- **로그인 페이지**: `http://localhost:8890/`
- **조회/청취 페이지**: `http://localhost:8890/inquiry`
- **백엔드 API**: `http://localhost:8890/api/*` (Laravel API)

**참고**: Monorepo 구조로 전환되어 Laravel 앱은 `apps/ipx-vr/`에 위치합니다.

## 데이터베이스 접속 정보

### 외부 접속 (DBeaver, 로컬 개발 도구)
- **Host**: `127.0.0.1`
- **Port**: `3307`
- **Admin**: `root` / `st5300!@#`
- **App**: `ipx_app` / `strong_password`

### 내부 접속 (Laravel 컨테이너)
- **Host**: `mariadb` (Docker Service Name)
- **Port**: `3306`
- **User**: `ipx_app` / `strong_password`

자세한 내용: [`/docs/system/database-connection-spec.md`](docs/system/database-connection-spec.md)

## 개발 방법론

이 프로젝트는 **Poly Vibe Coding Method**를 따릅니다:

- **Spec-Driven**: OpenSpec 기반 개발
- **TDD**: Test Driven Development
- **Context-Aware**: 상태 추적 및 공유
- **Fail-Fast**: 조기 오류 발견 및 복구
- **Interface-First & DI**: 계약 우선 설계

자세한 내용은 `/guide` 폴더의 문서를 참조하세요.

## 주요 기능

### 백엔드 (Laravel)
- **RESTful API**: API First 전략, JSON 데이터 교환
- **비동기 큐 시스템**: Laravel Queue + Redis를 통한 AI 작업 처리
- **Service Layer**: 비즈니스 로직 계층 분리
- **Multi-Database**: 관심사 분리된 데이터베이스 아키텍처
- **인증/권한**: Laravel Sanctum + Spatie Permission

### 프론트엔드 (Vue.js)
- **SPA (Single Page Application)**: 클라이언트 사이드 라우팅
- **상태 관리**: Pinia를 통한 전역 상태 관리
- **API 통신**: Axios를 통한 Laravel API 호출

### 인프라
- **고성능 처리**: Nginx Event-Driven + PHP-FPM 최적화
- **AI 통합**: STT, LLM 분석 파이프라인
- **실시간 모니터링**: Laravel Horizon 대시보드

## 참고 문서

### 개발 가이드
- [`/guide/00-setup.md`](guide/00-setup.md) - 개발 환경 구축 가이드
- [`/guide/01-principles.md`](guide/01-principles.md) - 개발 원칙
- [`/guide/02-openspec.md`](guide/02-openspec.md) - OpenSpec 가이드
- [`/guide/03-execution.md`](guide/03-execution.md) - 실행 가이드
- [`/guide/ipx-framework.md`](guide/ipx-framework.md) - 프레임워크 아키텍처

### 데이터베이스
- [`/docs/system/database-connection-spec.md`](docs/system/database-connection-spec.md) - 접속 명세서
- [`/docs/system/database-architecture.md`](docs/system/database-architecture.md) - 아키텍처

### 시스템 현황
- [`/docs/system/project-status.md`](docs/system/project-status.md) - 프로젝트 전체 현황
- [`/docs/system/frontend-status.md`](docs/system/frontend-status.md) - 프론트엔드 개발 현황

### 빠른 참조
- [`QUICKSTART.md`](QUICKSTART.md) - 빠른 시작 가이드
- [`DEVELOPMENT.md`](DEVELOPMENT.md) - 개발 가이드

## 라이선스

[라이선스 정보]
