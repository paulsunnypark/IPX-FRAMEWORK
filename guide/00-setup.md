# 00 — 개발 환경 구축 가이드

## 개요

IPX-Framework 개발 환경을 구축하는 단계별 가이드입니다.

---

## 1. 사전 요구사항

### 필수 도구
- **Docker** 20.10+ & **Docker Compose** 2.0+
- **Git** 2.30+

### 선택 도구 (로컬 개발 시)
- **PHP** 8.4+ (FPM)
- **Composer** 2.6+
- **Node.js** 18+ & **npm** 9+

---

## 2. 프로젝트 초기화

### 2.1 저장소 클론

```bash
git clone <repository-url>
cd ipx-framework
```

### 2.2 Laravel 프로젝트 확인

Laravel 11이 이미 설치되어 있습니다. 의존성만 설치하면 됩니다:

```bash
# Docker 컨테이너에서 의존성 설치
docker-compose exec php composer install
```

### 2.3 환경 변수 설정

`.env` 파일은 이미 Multi-Database 설정으로 준비되어 있습니다.

```bash
# 애플리케이션 키 생성
docker-compose exec php php artisan key:generate
```

### 2.4 의존성 설치

```bash
# PHP 의존성
composer install

# Node.js 의존성
npm install
```

---

## 3. Docker 환경 실행

### 3.1 컨테이너 빌드 및 실행

```bash
# 컨테이너 빌드 및 시작
docker-compose up -d --build

# 로그 확인
docker-compose logs -f
```

### 3.2 서비스 확인

```bash
# 실행 중인 컨테이너 확인
docker-compose ps

# 각 서비스 상태 확인
docker-compose exec php php -v
docker-compose exec nginx nginx -v
docker-compose exec mysql mysql --version
docker-compose exec redis redis-cli ping
```

### 3.3 데이터베이스 설정

Multi-Database 구조이므로 각 데이터베이스별로 마이그레이션을 실행합니다:

```bash
# Master DB 마이그레이션
docker-compose exec php php artisan migrate --database=mysql_master

# VR DB 마이그레이션
docker-compose exec php php artisan migrate --database=mysql_vr

# 시드 데이터 생성 (선택)
docker-compose exec php php artisan db:seed --database=mysql_master

# 스토리지 링크 생성
docker-compose exec php php artisan storage:link
```

데이터베이스는 Docker 컨테이너 시작 시 자동으로 생성됩니다.

---

## 4. 개발 서버 실행

### 4.1 백엔드 (Laravel)

Docker 환경에서는 Nginx가 자동으로 PHP-FPM과 연동되므로 별도 실행 불필요.

로컬 개발 서버를 사용하려면:

```bash
# Docker 환경에서
docker-compose exec php php artisan serve --host=0.0.0.0 --port=8000

# 로컬 환경에서
php artisan serve
```

### 4.2 프론트엔드 (Vue.js)

```bash
# Vite 개발 서버 실행
npm run dev

# 또는 Docker 환경에서
docker-compose exec php npm run dev
```

접속 URL: `http://localhost:5173`

### 4.3 Queue Worker

```bash
# 기본 Queue Worker
docker-compose exec php php artisan queue:work redis --tries=3

# 또는 Horizon 대시보드 사용 (권장)
docker-compose exec php php artisan horizon
```

Horizon 대시보드: `http://localhost/horizon` (설정 필요)

---

## 5. 프로젝트 구조 확인

초기화 후 다음 구조가 생성되어야 합니다:

```
ipx-framework/
├── app/                    # Laravel 애플리케이션
│   ├── Http/
│   │   ├── Controllers/
│   │   └── Requests/
│   ├── Models/
│   ├── Services/           # 비즈니스 로직
│   ├── Jobs/               # 비동기 작업
│   └── Events/
├── docker/                 # Docker 설정
│   ├── nginx/
│   ├── php/
│   └── redis/
├── resources/
│   └── js/                 # Vue.js 소스
├── routes/
│   └── api.php
├── tasks/                   # 작업과제 (개발 관리)
│   ├── prd-template.md
│   ├── tasks-template.md
│   └── context-contraction.md
├── docs/                    # 산출물 문서
│   ├── user-manual/         # 사용자 메뉴얼
│   ├── system/              # 시스템 문서
│   ├── api/                 # API 문서
│   └── reports/             # 보고서
├── guide/                   # 개발 가이드
├── docker-compose.yml
├── composer.json
└── package.json
```

### 문서 디렉토리 구분
- **`/tasks`**: 작업과제, PRD, 작업 계획 등 개발 과정 문서
- **`/docs`**: 사용자 메뉴얼, 시스템 구성도, 중간/최종 보고서 등 산출물 문서

---

## 6. 개발 워크플로우 시작

### 6.1 첫 번째 작업 시작

1. **분석!** - PRD 생성
   ```bash
   # /tasks/prd-[project].md 파일 생성
   ```

2. **계획!** - 작업 계획 수립
   ```bash
   # /tasks/tasks-prd-[project].md 파일 생성
   ```

3. **실행!** - 작업 수행
   ```bash
   # TDD 기반 구현
   ```

자세한 내용은 `/guide/03-execution.md`를 참조하세요.

---

## 7. 문제 해결

### 7.1 Docker 컨테이너 문제

```bash
# 컨테이너 재시작
docker-compose restart

# 컨테이너 재빌드
docker-compose up -d --build

# 볼륨 삭제 후 재시작 (주의: 데이터 삭제)
docker-compose down -v
docker-compose up -d
```

### 7.2 권한 문제

```bash
# 스토리지 및 캐시 디렉토리 권한 설정
docker-compose exec php chmod -R 775 storage bootstrap/cache
docker-compose exec php chown -R www-data:www-data storage bootstrap/cache
```

### 7.3 Composer 의존성 문제

```bash
# 캐시 삭제 후 재설치
docker-compose exec php composer clear-cache
docker-compose exec php composer install --no-cache
```

### 7.4 데이터베이스 연결 문제

```bash
# .env 파일의 DB 설정 확인
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=ipx_framework
DB_USERNAME=ipx_user
DB_PASSWORD=ipx_password

# MySQL 컨테이너 로그 확인
docker-compose logs mysql
```

### 7.5 Redis 연결 문제

```bash
# Redis 컨테이너 상태 확인
docker-compose exec redis redis-cli ping

# Redis 로그 확인
docker-compose logs redis
```

---

## 8. 다음 단계

환경 구축이 완료되면:

1. `/guide/01-principles.md` - 개발 원칙 학습
2. `/guide/02-openspec.md` - OpenSpec 작성 방법 학습
3. `/guide/03-execution.md` - 실행 워크플로우 학습
4. `/guide/ipx-framework.md` - 프레임워크 아키텍처 이해

---

## 참고 자료

- [Laravel 11 문서](https://laravel.com/docs/11.x)
- [Vue.js 3 문서](https://vuejs.org/)
- [Docker 문서](https://docs.docker.com/)
- [Nginx 문서](https://nginx.org/en/docs/)

