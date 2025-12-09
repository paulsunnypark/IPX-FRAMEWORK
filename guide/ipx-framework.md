[Master Plan] New-IPX-Framework 구축 전략서
: AI 융합형 통신 솔루션을 위한 차세대 고성능 아키텍처
1. 개요 (Overview)
본 프레임워크는 기존 레거시 시스템의 한계(동기식 처리, 스파게티 코드)를 극복하고, **대용량 트래픽(통신)**과 **장시간 프로세스(AI 분석)**를 안정적으로 처리하기 위해 설계되었습니다.
Apache 대신 **Nginx(Event-Driven)**를 도입하고, **Laravel(Queue)**을 통해 비동기 처리를 표준화하여 **"압도적인 생산성"**과 **"시스템 안정성"**을 동시에 확보합니다.

2. Tech Stack: 최상의 기술 조합 (The Winning Combo)
검증된 De-facto Standard(사실상의 표준) 기술을 채택하여, 인력 수급의 용이성과 기술 부채 제로를 지향합니다.
영역
구성 요소
버전 및 선정 전략
Web Server
Nginx
1.25+ (Alpine)

Event-Driven 아키텍처. 정적 리소스 직접 처리 및 PHP-FPM 로드 밸런싱 담당. Apache 대비 동시 접속 처리 효율 10배 이상.
Backend
PHP
8.4+ (FPM Mode)

JIT(Just-In-Time) 컴파일러 활성화. Apache 모듈 방식이 아닌 독립된 FPM 프로세스로 동작하여 메모리 누수 방지 및 고성능 보장.
Framework
Laravel
11.x

전 세계 1위 프레임워크. 큐(Queue), 스케줄링, 웹소켓(Reverb), 보안 기능 내장. 바닥부터 개발하지 않고 생태계를 활용.
API
RESTful
Standard JSON

철저한 API First 전략. 화면(View)을 리턴하지 않고 데이터(JSON)만 교환. (Spatie Laravel Data 패키지로 DTO 관리)
Frontend
Vue.js
3.x (Composition API)

<script setup> 문법 사용. TypeScript 도입 권장. Vite를 빌드 도구로 사용하여 DX(개발자 경험) 극대화.
State
Pinia
2.x

Vuex를 대체하는 경량화된 공식 상태 관리 라이브러리. 직관적인 Store 패턴 제공.
Database
MariaDB 10.6+ (현재: 10.11.7)

JSON 컬럼 타입 적극 활용(비정형 AI 데이터 저장). CTE(Common Table Expression)를 활용한 통계 쿼리 최적화. MySQL 8.0+도 호환 가능.
Cache/Queue
Redis
7.x

[필수 코어] 세션 공유, DB 캐싱, 그리고 AI 비동기 작업 대기열(Queue) 관리의 핵심 엔진.
AI Sidecar
Python
FastAPI (Optional)

PHP에서 직접 처리하기 힘든 고연산 AI 로직이 필요할 경우, 내부 API로 호출하는 마이크로서비스 구조 채택.


3. Architecture: IPX-Core Framework 구조 설계
단순한 Laravel 프로젝트가 아닌, **인프라(Docker/Nginx)**와 **비즈니스 로직(Service/Job)**이 결합된 엔터프라이즈 구조입니다.
A. 디렉토리 및 인프라 구조 (Project Structure)
기존의 비대한 컨트롤러(Fat Controller) 방식을 폐기하고, 책임이 분리된 계층형 아키텍처를 적용합니다.
Plaintext
/ipx-new-framework (Root)
├── app/                            # [Backend Core]
│   ├── Http/
│   │   ├── Controllers/            # 가볍게 유지 (요청 수신 -> Service 호출 -> 응답 반환)
│   │   └── Requests/               # FormValidation 로직 분리 (유효성 검사)
│   ├── Models/                     # Eloquent ORM (데이터 관계 및 스코프 정의)
│   ├── Services/                   # [핵심] 비즈니스 로직 계층
│   │   ├── SttService.php          # STT 엔진 연동 로직
│   │   ├── AnalysisService.php     # LLM 프롬프트 및 분석 로직
│   │   └── StatService.php         # 통계 계산 로직
│   ├── Jobs/                       # [핵심] 비동기 작업 (Redis Queue)
│   │   ├── ProcessSttJob.php       # STT 변환 작업 (백그라운드 실행)
│   │   └── AnalyzeTalkJob.php      # 대화 분석 작업
│   └── Events/                     # 시스템 이벤트 (CallEnded, UserCreated 등)
│
├── docker/                         # [Infrastructure as Code]
│   ├── nginx/
│   │   ├── nginx.conf              # Nginx 메인 설정
│   │   └── conf.d/default.conf     # Laravel 전용 서버 블록 설정 (Timeout 튜닝)
│   ├── php/
│   │   ├── Dockerfile              # PHP 8.4 + FPM + Extensions 설치 스크립트
│   │   └── php.ini                 # 메모리, 업로드 제한 설정
│   └── redis/                      # Redis 설정
│
├── public/                         # Nginx가 바라보는 웹 루트 (index.php, builds)
├── resources/js/                   # [Frontend] Vue.js 3 소스코드
├── routes/api.php                  # API 라우트 정의
├── docker-compose.yml              # 컨테이너 오케스트레이션 정의
└── vite.config.js                  # Frontend 빌드 설정


B. 데이터 흐름 (Data Flow) : 비동기 중심
Request: 프론트엔드(Vue)에서 Axios로 API 요청.
Nginx: 정적 파일은 직접 처리, PHP 요청은 PHP-FPM으로 전달.
Controller: 요청 유효성 검사(Request) 후 Service 호출.
Service: * 단순 조회: DB에서 조회 후 즉시 반환.
AI/분석: Jobs를 생성하여 Redis Queue에 등록하고, 사용자에게는 "요청 접수됨" 즉시 응답.
Worker: 백그라운드 프로세스가 Redis에서 작업을 꺼내 실행 후 DB 업데이트 및 알림 전송.

4. Infrastructure: Nginx & PHP-FPM 최적화 설정
AI 기능과 대용량 통계를 위해 Time-out 및 Buffer 설정이 핵심입니다. 이 설정을 docker/nginx/conf.d/default.conf에 적용합니다.
Nginx
server {
    listen 80;
    server_name localhost;
    root /var/www/html/public;
    index index.php index.html;

    # [Performance] 정적 파일 브라우저 캐싱 (1년)
    location ~* \.(jpg|jpeg|gif|png|css|js|ico|svg|woff2)$ {
        expires 365d;
        access_log off;
        add_header Cache-Control "public";
    }

    # [Security] 보안 헤더 적용
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    # [Routing] 모든 요청을 Laravel 프론트 컨트롤러로 위임
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # [Core] PHP-FPM 연동 및 AI 처리를 위한 튜닝
    location ~ \.php$ {
        fastcgi_pass php:9000;  # docker-compose 서비스명
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;

        # [AI Optimization] 긴 처리 시간을 대비한 타임아웃 증설
        # 실시간 분석 요청이 60초를 넘겨도 연결을 끊지 않음 (기본 60s -> 300s)
        fastcgi_read_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_connect_timeout 300;
        
        # [Buffer] 대용량 JSON 응답을 위한 버퍼 증설
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
    }

    # 숨겨진 시스템 파일 접근 차단
    location ~ /\.(?!well-known).* {
        deny all;
    }
}



5. Key Libraries: 필수 표준 라이브러리
개발 생산성과 코드 품질 균일화를 위해 아래 패키지를 표준으로 강제합니다.
Backend (Composer)
laravel/horizon: [필수] Redis Queue의 상태(대기 작업 수, 실패율, 처리 속도)를 시각화 대시보드로 제공. AI 시스템 모니터링의 핵심.
guzzlehttp/guzzle: 외부 STT/LLM 엔진과 통신하기 위한 HTTP 클라이언트.
spatie/laravel-permission: 복잡한 관리자/사용자/상담원 권한(Role) 관리.
laravel/sanctum: Vue.js SPA와 백엔드 간의 토큰 기반 인증(API Token) 처리.
barryvdh/laravel-ide-helper: PHPStorm/VSCode 자동완성 지원 (생산성 2배 향상).
Frontend (NPM)
axios: 백엔드 통신 표준.
@tanstack/vue-query: [강력 추천] 서버 데이터 캐싱, 자동 재요청(Refetch), 로딩 상태 관리. 프론트엔드 복잡도를 획기적으로 낮춤.
primevue (또는 Element Plus): 엔터프라이즈급 UI 컴포넌트 (데이터 그리드, 캘린더, 다이얼로그 등).
chart.js + vue-chartjs: 호통계 및 대시보드 시각화.

6. AI Integration: 비동기 큐 구현 전략
가장 중요한 AI 기능은 사용자를 기다리게 하지 않는 비동기 큐(Asynchronous Queue) 시스템 위에서 돌아가야 합니다.
시나리오: 녹취 파일 STT 변환 및 요약 파이프라인
Frontend (Vue): 사용자가 [AI 분석] 버튼 클릭.
Controller (PHP): * 요청 유효성 검사.
ProcessSttJob::dispatch($recId) 호출 (Redis에 작업 등록).
return response()->json(['status' => 'processing']); (즉시 응답).
Redis (Queue): 작업 대기열에 Job 적재.
Worker (PHP-CLI): 백그라운드 데몬이 Queue에서 작업을 꺼냄.
Step 1: STT 엔진 API 호출 및 텍스트 변환.
Step 2: 변환된 텍스트를 LLM(AI)에 전송하여 요약/키워드 추출.
Step 3: 결과(rec_analysis 테이블) 저장 및 상태(status=completed) 업데이트.
(Option): Laravel Reverb(웹소켓)를 통해 프론트엔드에 "분석 완료" 알림 전송.
Frontend (Vue): 알림 수신 또는 Polling(Tanstack Query)으로 완료 상태 확인 후 결과 표시.

7. DevOps & Roadmap: 실행 가이드
Development Environment
Local: Laravel Sail (Docker Wrapper) 사용. 명령어 한 줄(sail up -d)로 Nginx, PHP 8.4, MySQL, Redis 환경 구동. 개발자 PC 환경 통일.
CI/CD: Git Push 시 GitHub Actions 또는 GitLab CI가 동작.
PHPUnit(단위 테스트) -> PHP CS Fixer(코드 스타일 검사) -> Docker Image 빌드 -> 배포.
Execution Roadmap (실행 계획)
Phase 1: 기반 구축 (1주)
Laravel 11 + Vue 3 + Docker(Nginx) 기반의 "IPX-Next-Skeleton" 프로젝트 생성.
Nginx 설정(Timeout, Buffer) 및 Docker Compose 구성 완료.
GitHub/GitLab 저장소 세팅 및 기본 브랜치 전략(Git Flow) 수립.
Phase 2: 공통 모듈 개발 (2주)
JWT/Sanctum 기반 인증(로그인) 구현.
RBAC(권한 관리) 시스템 및 메뉴 구조 설계.
표준 API 응답 포맷(ApiResponse Trait) 정의.
Phase 3: 호통계 시스템 이관 (1개월)
현재 개발 중인 호통계 시스템을 New-Framework 위로 이식.
Raw SQL을 Eloquent ORM으로 변환.
Vue.js 컴포넌트 구조화 및 Pinia 상태 관리 적용.
Phase 4: AI 모듈 탑재 (2주)
Redis 및 Laravel Horizon 설치.
STT/요약 기능을 Job 클래스로 구현 및 테스트.
대용량 처리를 위한 Worker 프로세스 최적화.
이 마스터 플랜은 단순한 웹 개발이 아닌, **"통신 엔터프라이즈 솔루션"**에 특화된 아키텍처입니다. 이 가이드를 토대로 개발 환경을 구성하신다면, 향후 5년 이상 지속 가능한 강력한 기술 경쟁력을 확보하실 수 있습니다.

