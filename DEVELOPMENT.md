# IPX-Framework 개발 가이드

## 개발 환경 구축

### 1. 사전 요구사항

- Docker & Docker Compose 2.0+
- Git
- (선택) PHP 8.4+ (로컬 개발 시)
- (선택) Node.js 18+ (프론트엔드 개발 시)

### 2. 프로젝트 초기화

```bash
# 1. 저장소 클론
git clone <repository-url>
cd ipx-framework

# 2. Docker 컨테이너 실행
docker-compose up -d

# 3. Laravel 의존성 설치
docker-compose exec php composer install

# 4. 애플리케이션 키 생성
docker-compose exec php php artisan key:generate

# 5. 데이터베이스 마이그레이션 (Multi-DB)
docker-compose exec php php artisan migrate --database=mysql_master
docker-compose exec php php artisan migrate --database=mysql_vr

# 6. 스토리지 링크 생성
docker-compose exec php php artisan storage:link

# 7. NPM 의존성 설치 (프론트엔드)
npm install
```

### 3. 개발 서버 실행

#### 백엔드 (Laravel)

Docker 환경에서는 Nginx가 자동으로 PHP-FPM과 연동되므로 별도 실행 불필요.

브라우저에서 `http://localhost` 접속

로컬 개발 서버를 사용하려면:
```bash
docker-compose exec php php artisan serve --host=0.0.0.0 --port=8000
```

#### 프론트엔드 (Vue.js)

```bash
# Vite 개발 서버 실행
npm run dev

# 또는 Docker 환경에서
docker-compose exec php npm run dev
```

#### Queue Worker (비동기 작업)

```bash
# Redis Queue Worker 실행
docker-compose exec php php artisan queue:work redis --tries=3

# 또는 Horizon 대시보드 사용
docker-compose exec php php artisan horizon
```

### 4. 개발 워크플로우

#### Poly Vibe Coding Method

1. **분석!** - PRD(OpenSpec) 생성
   - `/tasks/prd-[project].md` 파일 생성
   - 기술 계약 및 요구사항 정의

2. **계획!** - 작업 계획 수립
   - 상위 작업 생성 (`/tasks/tasks-prd-[project].md`)
   - 하위 작업 세분화

3. **실행!** - TDD 기반 구현
   - 테스트 작성 → 최소 구현 → 검증
   - `실행! N.M`으로 특정 작업 수행

4. **맥락축약!** - 결과 기록
   - `/tasks/context-contraction.md`에 상태 업데이트

5. **커밋!** - Git 커밋
   - Atomic Commit
   - Conventional Commits 규칙 준수

자세한 내용은 `/guide` 폴더의 문서를 참조하세요.

### 5. 주요 명령어

```bash
# Docker 관리
docker-compose up -d          # 컨테이너 시작
docker-compose down           # 컨테이너 중지
docker-compose logs -f php    # PHP 로그 확인
docker-compose exec php bash  # PHP 컨테이너 접속

# Laravel
docker-compose exec php php artisan migrate --database=mysql_master  # Master DB 마이그레이션
docker-compose exec php php artisan migrate --database=mysql_vr     # VR DB 마이그레이션
docker-compose exec php php artisan migrate:fresh --database=mysql_master  # DB 초기화
docker-compose exec php php artisan db:seed           # 시드 데이터 생성
docker-compose exec php php artisan route:list        # 라우트 목록
docker-compose exec php php artisan tinker            # REPL 실행

# Queue
php artisan queue:work        # Queue Worker 실행
php artisan queue:listen      # Queue Listener 실행
php artisan horizon           # Horizon 대시보드 실행

# 테스트
php artisan test              # PHPUnit 테스트 실행
php artisan test --filter=ClassName  # 특정 테스트만 실행

# 프론트엔드
npm run dev                   # 개발 서버
npm run build                 # 프로덕션 빌드
npm run test                  # 테스트 실행
```

### 6. 디렉토리 구조

```
/ipx-framework
├── app/
│   ├── Http/
│   │   ├── Controllers/      # 가벼운 컨트롤러
│   │   └── Requests/         # Form Validation
│   ├── Models/               # Eloquent ORM
│   ├── Services/             # 비즈니스 로직
│   ├── Jobs/                 # 비동기 작업
│   └── Events/               # 이벤트
├── docker/                   # Docker 설정
├── resources/
│   └── js/                   # Vue.js 소스
├── routes/
│   └── api.php               # API 라우트
├── tests/                    # 테스트
├── tasks/                    # 작업과제 (개발 관리)
│   ├── prd-*.md             # OpenSpec 문서
│   ├── tasks-prd-*.md       # 작업 계획
│   └── context-contraction.md
└── docs/                     # 산출물 문서
    ├── user-manual/          # 사용자 메뉴얼
    ├── system/               # 시스템 문서
    ├── api/                  # API 문서
    └── reports/              # 보고서
```

### 문서 관리 규칙
- **`/tasks`**: 작업과제, PRD, 작업 계획 등 개발 과정 문서
- **`/docs`**: 사용자 메뉴얼, 시스템 구성도, 중간/최종 보고서 등 산출물 문서

### 7. 코딩 컨벤션

- **PSR-12**: PHP 코딩 표준 준수
- **Interface-First**: 인터페이스 우선 설계
- **Service Layer**: 비즈니스 로직은 Service에 구현
- **TDD**: 테스트 우선 작성
- **Fail-Fast**: 조기 오류 발견

### 8. 문제 해결

#### Docker 컨테이너가 시작되지 않을 때

```bash
# 로그 확인
docker-compose logs

# 컨테이너 재시작
docker-compose restart

# 볼륨 삭제 후 재시작 (주의: 데이터 삭제됨)
docker-compose down -v
docker-compose up -d
```

#### 권한 문제

```bash
# 스토리지 권한 설정
docker-compose exec php chmod -R 775 storage bootstrap/cache
docker-compose exec php chown -R www-data:www-data storage bootstrap/cache
```

#### Composer 의존성 문제

```bash
# 캐시 삭제 후 재설치
docker-compose exec php composer clear-cache
docker-compose exec php composer install --no-cache
```

