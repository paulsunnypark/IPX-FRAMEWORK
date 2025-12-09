# 다음 단계 작업 가이드

**작성일**: 2024-12-09  
**상태**: 준비 완료

## 📋 현재 상태 요약

### ✅ 완료된 작업
1. **인프라 구축**
   - Docker 환경 구성 (Nginx, PHP-FPM, MariaDB, Redis)
   - Windows Docker 환경 최적화 (Named Volume)
   - Monorepo 구조 전환 (`apps/ipx-vr/`)

2. **백엔드 설정**
   - Laravel 11 설치 및 설정
   - Multi-Database 구조 설정 (`ipx_master`, `ipx_vr`)
   - 데이터베이스 접속 정보 설정 완료

3. **프론트엔드 설정**
   - Vue 3 + PrimeVue + Tailwind CSS 환경 구축
   - Vite 개발 서버 포트 분리 (5173)
   - 로그인 페이지 및 조회/청취 페이지 개발 완료
   - 프론트엔드 정상 작동 확인

4. **버전 관리**
   - GitHub 저장소 초기화 및 푸시 완료
   - `.gitignore` 최적화 완료

## 🎯 다음 단계 작업 계획

### Phase 1: 데모 데이터 통합 (우선순위: 높음)

#### 1.1 Docker 볼륨 마운트 설정
- [ ] `docker-compose.yml`에 Windows 파일 시스템 마운트 확인
- [ ] 녹취 파일 경로: `D:\IPX-Storage\FILES\VR_REC:/var/www/recordings_root`
- [ ] 마운트 테스트 및 접근 확인

#### 1.2 데이터베이스 스키마 설계
- [ ] `recordings` 테이블 마이그레이션 생성
- [ ] `transcriptions` 테이블 마이그레이션 생성
- [ ] `analyses` 테이블 마이그레이션 생성
- [ ] 관계 설정 (Foreign Keys)

#### 1.3 파일 파서 서비스 구현
- [ ] `FileParserService` 생성
- [ ] 파일명 패턴 분석 (Type A, Type B)
- [ ] JSON 파일 파싱 로직 (`_asr.json`, `_cvt.json`)
- [ ] 메타데이터 추출 및 검증

#### 1.4 Import Command 개발
- [ ] `php artisan make:command ImportDemoFiles`
- [ ] 재귀적 파일 스캔 로직
- [ ] DB 중복 체크 및 스킵 로직
- [ ] 진행 상황 표시 (Progress Bar)

#### 1.5 모델 생성
- [ ] `Recording` 모델 생성
- [ ] `Transcription` 모델 생성
- [ ] `Analysis` 모델 생성
- [ ] 관계 메서드 정의

### Phase 2: API 개발 (우선순위: 높음)

#### 2.1 인증 시스템
- [ ] Laravel Sanctum 설치 및 설정
- [ ] 로그인 API (`/api/auth/login`) 구현
- [ ] 토큰 기반 인증 미들웨어 설정
- [ ] Pinia Auth Store 생성
- [ ] Vue Router 가드 구현

#### 2.2 녹취 목록 API
- [ ] `RecordingController` 생성
- [ ] 목록 조회 API (`GET /api/recordings`)
- [ ] 필터링 (기간, 상담원, 고객번호 등)
- [ ] 페이징 처리
- [ ] 정렬 기능

#### 2.3 녹취 상세 API
- [ ] 상세 조회 API (`GET /api/recordings/{id}`)
- [ ] STT 텍스트 조회
- [ ] AI 분석 결과 조회
- [ ] 관련 파일 정보 조회

#### 2.4 파일 스트리밍 API
- [ ] 재생 API (`GET /api/recordings/{id}/play`)
- [ ] 다운로드 API (`GET /api/recordings/{id}/download`)
- [ ] Range Request 지원 (HTTP 206)
- [ ] 파일 존재 여부 검증

### Phase 3: 프론트엔드 고도화 (우선순위: 중간)

#### 3.1 API 연동
- [ ] TanStack Query로 실제 데이터 페칭
- [ ] 로딩 상태 처리
- [ ] 에러 처리 및 사용자 피드백
- [ ] 무한 스크롤 또는 페이지네이션

#### 3.2 녹취 상세 화면
- [ ] 상세 페이지 라우트 추가
- [ ] 탭 네비게이션 (음성텍스트, 텍스트, 요약, 구분, 키워드, 감성분석)
- [ ] 대화 내용 표시 컴포넌트 (채팅 형식)
- [ ] 음성 재생 플레이어 통합

#### 3.3 추가 기능
- [ ] 파일 다운로드 기능
- [ ] 엑셀 다운로드 기능
- [ ] 다중 선택 및 일괄 작업
- [ ] 실시간 업데이트 (WebSocket 또는 Polling)

### Phase 4: 추가 페이지 개발 (우선순위: 낮음)

- [ ] 다운로드 내역 페이지
- [ ] 데이터관리 페이지
- [ ] 통계 페이지
- [ ] 환경설정 페이지

## 🔧 개발 환경 준비

### 필수 확인 사항
- [ ] Docker 컨테이너 실행 중 (`docker-compose up -d`)
- [ ] Vite 개발 서버 실행 중 (`cd apps/ipx-vr && npm run dev`)
- [ ] 데이터베이스 접속 확인
- [ ] GitHub 저장소 최신 상태 확인

### 개발 워크플로우
1. **작업 시작 전**
   ```bash
   # 최신 코드 가져오기
   git pull origin main
   
   # Docker 컨테이너 확인
   docker-compose ps
   
   # Vite 개발 서버 확인
   # (별도 터미널에서 실행 중이어야 함)
   ```

2. **작업 중**
   - TDD 방식으로 테스트 작성 후 구현
   - 작은 단위로 커밋 (Atomic Commits)
   - Conventional Commits 규칙 준수

3. **작업 완료 후**
   ```bash
   # 변경 사항 확인
   git status
   
   # 커밋
   git add .
   git commit -m "feat: [작업 내용]"
   
   # 푸시
   git push origin main
   ```

## 📚 참고 문서

### 개발 가이드
- [프로젝트 현황](project-status.md) - 전체 프로젝트 상태
- [Context Contraction](../../tasks/context-contraction.md) - 최신 상태 로그
- [데모 데이터 통합 PRD](../../tasks/prd-demo-data-integration.md) - Phase 1 요구사항
- [데모 데이터 통합 작업 계획](../../tasks/tasks-prd-demo-data-integration.md) - Phase 1 작업 목록

### 기술 문서
- [데이터베이스 접속 명세서](database-connection-spec.md) - DB 접속 정보
- [포트 구성](port-configuration.md) - 포트 매핑 정보
- [프론트엔드 현황](frontend-status.md) - 프론트엔드 개발 상태

## 🚀 빠른 시작 명령어

### Docker 환경
```bash
# 컨테이너 시작
docker-compose up -d

# 컨테이너 상태 확인
docker-compose ps

# 로그 확인
docker-compose logs -f [service_name]
```

### Laravel
```bash
# PHP 컨테이너 접속
docker-compose exec php sh

# 마이그레이션 실행
php artisan migrate --database=mysql_vr

# 커맨드 실행
php artisan ipx:import-demo
```

### 프론트엔드
```bash
# 개발 서버 실행
cd apps/ipx-vr
npm run dev

# 프로덕션 빌드
npm run build
```

## 📝 다음 작업 시작 시 체크리스트

1. [ ] `tasks/context-contraction.md` 최신 내용 확인
2. [ ] `docs/system/project-status.md` 현재 상태 확인
3. [ ] 작업할 Phase 및 Task 선택
4. [ ] 관련 PRD 및 작업 계획 문서 확인
5. [ ] 개발 환경 준비 확인
6. [ ] 작업 시작!

---

**작성자**: AI Assistant  
**마지막 업데이트**: 2024-12-09

