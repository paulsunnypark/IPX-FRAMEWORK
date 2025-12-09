# IPX-Framework 프로젝트 현황

**최종 업데이트**: 2024-12-09 (Vite/Tailwind 설정 완료)

**구조 변경**: Monorepo 구조로 전환 완료 (`apps/ipx-vr/`) ✅ - [상세 내용](monorepo-migration.md)

## 프로젝트 개요

IPX-Framework는 AI 융합형 통신 솔루션을 위한 차세대 고성능 아키텍처 프레임워크입니다.

### 기술 스택
- **Backend**: Laravel 11.x (PHP 8.4+)
- **Frontend**: Vue.js 3.x + PrimeVue + Tailwind CSS
- **Database**: MariaDB 10.11+ (Multi-Database)
- **Infrastructure**: Docker (Nginx, PHP-FPM, MariaDB, Redis)
- **Build Tool**: Vite

## ✅ 완료된 작업

### 1. 개발 환경 구축
- ✅ Docker 환경 구성 (Nginx, PHP-FPM, MariaDB, Redis)
- ✅ Windows Docker 환경 최적화 (Named Volume 사용)
- ✅ Laravel 11 설치 및 설정
- ✅ Multi-Database 구조 설정 (`ipx_master`, `ipx_vr`)
- ✅ .env 파일 Multi-DB 설정 완료
- ✅ config/database.php Multi-DB 연결 설정 완료

### 2. 프론트엔드 개발 환경
- ✅ Vue 3.5.25 + PrimeVue 3.53.1 + Tailwind CSS 설정
- ✅ Vue Router, Pinia, TanStack Query 설정
- ✅ Vite 개발 서버 포트 분리 (5173)
- ✅ Tailwind CSS 설정 완료 (Monorepo 구조 반영)
- ✅ Vite fs.allow 설정 완료 (node_modules 접근 허용)
- ✅ 로그인 페이지 개발 완료
- ✅ 조회/청취 페이지 개발 완료
- ✅ 브라우저 테스트 완료 (`http://localhost:8890`)

### 3. 데이터베이스
- ✅ MariaDB 10.11 Docker 컨테이너 설정
- ✅ Multi-Database 구조 설계 완료
- ✅ 데이터베이스 접속 정보 설정 완료

### 4. 개발 계획 수립
- ✅ 데모 데이터 통합 PRD 작성
- ✅ 데모 데이터 통합 작업 계획 수립

## ⚠️ 진행 중 / 다음 작업

### 1. 데모 데이터 통합 (Phase 1)
- [ ] Docker 볼륨 마운트 설정 (Windows 파일 시스템)
- [ ] 데이터베이스 스키마 설계 및 마이그레이션
- [ ] 파일 파서 서비스 구현
- [ ] Import Command 개발
- [ ] Recording 모델 생성
- [ ] API 엔드포인트 구현 (목록, 재생, 다운로드)
- [ ] 프론트엔드 연동

### 2. API 개발
- [ ] Laravel 백엔드 API 엔드포인트 개발
- [ ] 인증 시스템 구현 (Laravel Sanctum)
- [ ] TanStack Query로 실제 데이터 연동

### 3. 추가 기능
- [ ] 녹취 상세 화면 개발
- [ ] 파일 다운로드 기능
- [ ] 음성 재생 플레이어
- [ ] 실시간 업데이트

## 시스템 구성

### 포트 구성
| 서비스 | 포트 | 설명 |
| :-- | :-- | :-- |
| **프론트엔드 (Laravel)** | 8890 | Vue.js SPA |
| **Vite 개발 서버** | 5173 | HMR (Hot Module Replacement) |
| **MariaDB (외부)** | 3307 | DBeaver 접속용 |
| **MariaDB (내부)** | 3306 | Laravel 접속용 |
| **Redis** | 6379 | 캐시 및 큐 |

### 데이터베이스 구조
- **ipx_master**: 공통/인증 DB (SSO, 조직도, 권한)
- **ipx_vr**: 녹취 전용 DB (녹취 메타데이터, AI 분석)

### Docker 서비스
- **nginx**: 웹 서버 (포트 8890)
- **php**: PHP-FPM + Laravel
- **mariadb**: MariaDB 10.11
- **redis**: Redis 7.x

## 파일 구조

```
/ipx-framework
├── apps/
│   └── ipx-vr/            # VR 애플리케이션 (Laravel)
│       ├── app/           # Backend Core (Laravel)
│       │   ├── Http/
│       │   ├── Models/
│       │   ├── Services/
│       │   └── Console/Commands/
│       ├── resources/js/  # Frontend (Vue.js 3)
│       │   ├── main.js
│       │   ├── App.vue
│       │   ├── router/
│       │   └── pages/
│       ├── public/        # 웹 루트
│       ├── config/
│       ├── database/
│       └── routes/
├── docker/                 # Infrastructure as Code
│   ├── nginx/
│   ├── php/
│   └── mariadb/
├── tasks/                  # 작업과제 (개발 관리)
│   ├── prd-demo-data-integration.md
│   ├── tasks-prd-demo-data-integration.md
│   └── context-contraction.md
└── docs/                   # 산출물 문서
    ├── system/
    ├── api/
    └── reports/
```

## 주요 설정 파일

### Docker
- `docker-compose.yml`: 서비스 정의 및 볼륨 설정
- `docker/nginx/nginx.conf`: Nginx 메인 설정
- `docker/nginx/conf.d/default.conf`: Laravel 서버 블록
- `docker/php/Dockerfile`: PHP 8.4 FPM 이미지
- `docker/php/php.ini`: PHP 설정

### Laravel
- `.env`: 환경 변수 (Multi-DB 설정 포함)
- `config/database.php`: 데이터베이스 연결 설정
- `config/logging.php`: 로깅 설정 (Windows Docker 호환)

### Frontend
- `apps/ipx-vr/vite.config.js`: Vite 빌드 설정 (Monorepo 구조 반영)
- `apps/ipx-vr/tailwind.config.js`: Tailwind CSS 설정 (Monorepo 구조 반영)
- `apps/ipx-vr/package.json`: NPM 패키지 정의

## 접속 정보

### 웹 애플리케이션
- **프론트엔드**: `http://localhost:8890`
- **로그인 페이지**: `http://localhost:8890/`
- **조회/청취 페이지**: `http://localhost:8890/inquiry`

### 데이터베이스
- **외부 접속**: `127.0.0.1:3307`
  - Admin: `root` / `st5300!@#`
  - App: `ipx_app` / `strong_password`
- **내부 접속**: `mariadb:3306`
  - App: `ipx_app` / `strong_password`

## 개발 워크플로우

### 1. 개발 서버 실행
```bash
# Docker 컨테이너 시작
docker-compose up -d

# Vite 개발 서버 실행 (프론트엔드)
npm run dev
```

### 2. 데이터베이스 마이그레이션
```bash
# Master DB
docker-compose exec php php artisan migrate --database=mysql_master

# VR DB
docker-compose exec php php artisan migrate --database=mysql_vr
```

### 3. 프로덕션 빌드
```bash
npm run build
```

## 참고 문서

### 시작하기
- [README.md](../../README.md) - 프로젝트 개요
- [QUICKSTART.md](../../QUICKSTART.md) - 빠른 시작 가이드

### 개발 가이드
- [개발 환경 구축](../../guide/00-setup.md)
- [개발 원칙](../../guide/01-principles.md)
- [프레임워크 아키텍처](../../guide/ipx-framework.md)

### 시스템 문서
- [데이터베이스 접속 명세서](database-connection-spec.md)
- [데이터베이스 아키텍처](database-architecture.md)
- [프론트엔드 개발 현황](frontend-status.md)
- [포트 구성](port-configuration.md)
- [Windows Docker 최적화](windows-docker-volume-solution.md)

### 작업 관리
- [Context Contraction](../../tasks/context-contraction.md) - 상태 추적 로그
- [데모 데이터 통합 PRD](../../tasks/prd-demo-data-integration.md)
- [데모 데이터 통합 작업 계획](../../tasks/tasks-prd-demo-data-integration.md)

---

**다음 작업**: 데모 데이터 통합 Phase 1 시작

