# Tasks – 데모 데이터 통합 (Demo Data Integration)

이 문서는 PRD 기반으로 생성된 작업 계획입니다.

## 상위 작업

- [ ] 1. Docker 볼륨 마운트 설정
- [ ] 2. 데이터베이스 스키마 설계 및 마이그레이션
- [ ] 3. 파일 파서 서비스 구현
- [ ] 4. Import Command 구현
- [ ] 5. Recording 모델 및 관계 정의
- [ ] 6. API 엔드포인트 구현
- [ ] 7. 파일 스트리밍 서비스 구현
- [ ] 8. 프론트엔드 연동
- [ ] 9. 테스트 작성
- [ ] 10. 문서화

---

## 하위 작업

### 1. Docker 볼륨 마운트 설정
- [ ] 1.1 `docker-compose.yml`에 Windows 파일 시스템 볼륨 마운트 추가
- [ ] 1.2 볼륨 마운트 경로 확인 (`/var/www/recordings_root`)
- [ ] 1.3 컨테이너 재생성 및 마운트 확인
- [ ] 1.4 파일 접근 권한 테스트

### 2. 데이터베이스 스키마 설계 및 마이그레이션
- [ ] 2.1 `recordings` 테이블 마이그레이션 생성
- [ ] 2.2 `transcriptions` 테이블 마이그레이션 생성
- [ ] 2.3 `analyses` 테이블 마이그레이션 생성
- [ ] 2.4 인덱스 최적화 (검색 성능)
- [ ] 2.5 VR DB 마이그레이션 실행

### 3. 파일 파서 서비스 구현
- [ ] 3.1 `FileParserService` 인터페이스 정의
- [ ] 3.2 Type A 파서 구현 (`YYYYMMDDHHMMSS_PHONE_EXT_*_*.wav`)
- [ ] 3.3 Type B 파서 구현 (`M_YYYYMMDDHHMMSS_*_*.wav`)
- [ ] 3.4 파서 전략 패턴 적용 (확장 가능)
- [ ] 3.5 파싱 오류 처리 로직

### 4. Import Command 구현
- [ ] 4.1 `php artisan make:command ImportDemoFiles` 실행
- [ ] 4.2 파일 시스템 재귀 스캔 로직 구현
- [ ] 4.3 중복 파일 체크 로직
- [ ] 4.4 JSON 파일(`*_asr.json`, `*_cvt.json`) 처리 로직
- [ ] 4.5 진행 상황 표시 (Progress Bar)
- [ ] 4.6 오류 로깅 및 리포트 생성
- [ ] 4.7 청크 단위 처리 (메모리 최적화)

### 5. Recording 모델 및 관계 정의
- [ ] 5.1 `Recording` 모델 생성 (`ipx_vr` 연결)
- [ ] 5.2 `Transcription` 모델 생성
- [ ] 5.3 `Analysis` 모델 생성
- [ ] 5.4 모델 관계 정의 (`hasOne`, `hasMany`)
- [ ] 5.5 Accessor/Mutator 구현 (URL 생성 등)
- [ ] 5.6 Scope 메서드 구현 (검색 필터)

### 6. API 엔드포인트 구현
- [ ] 6.1 API 라우트 정의 (`routes/api.php`)
- [ ] 6.2 `RecordingController` 생성
- [ ] 6.3 목록 조회 API 구현 (`GET /api/v1/recordings`)
  - [ ] 6.3.1 페이징 처리
  - [ ] 6.3.2 필터링 (기간, 고객번호, 사용자명 등)
  - [ ] 6.3.3 정렬 기능
- [ ] 6.4 상세 조회 API 구현 (`GET /api/v1/recordings/{id}`)
- [ ] 6.5 재생 API 구현 (`GET /api/v1/recordings/{id}/play`)
- [ ] 6.6 다운로드 API 구현 (`GET /api/v1/recordings/{id}/download`)
- [ ] 6.7 Request Validation 클래스 생성
- [ ] 6.8 Response DTO 생성

### 7. 파일 스트리밍 서비스 구현
- [ ] 7.1 `StorageService` 생성
- [ ] 7.2 파일 경로 조합 로직 (Path Traversal 방지)
- [ ] 7.3 파일 존재 여부 확인
- [ ] 7.4 Range Requests 지원 (HTTP 206 Partial Content)
- [ ] 7.5 적절한 Content-Type 헤더 설정
- [ ] 7.6 파일 크기 제한 검증
- [ ] 7.7 스트리밍 응답 최적화

### 8. 프론트엔드 연동
- [ ] 8.1 TanStack Query로 API 호출 구현
- [ ] 8.2 Mock 데이터를 실제 API 응답으로 교체
- [ ] 8.3 재생 버튼 클릭 시 스트리밍 URL 연결
- [ ] 8.4 다운로드 버튼 기능 구현
- [ ] 8.5 로딩 상태 및 오류 처리
- [ ] 8.6 페이징 UI 연동

### 9. 테스트 작성
- [ ] 9.1 `FileParserService` Unit Test
- [ ] 9.2 `StorageService` Unit Test
- [ ] 9.3 `ImportDemoFiles` Command Test
- [ ] 9.4 `RecordingController` Feature Test
- [ ] 9.5 파일 스트리밍 Integration Test
- [ ] 9.6 Range Requests 테스트

### 10. 문서화
- [ ] 10.1 API 문서 작성 (`docs/api/recordings-api.md`)
- [ ] 10.2 Import Command 사용 가이드 작성
- [ ] 10.3 파일명 패턴 문서화
- [ ] 10.4 트러블슈팅 가이드 작성

---

## 진행 상황

- **시작일**: 2024-12-09
- **예상 완료일**: 2024-12-15
- **현재 진행률**: 0%

## 우선순위

### Phase 1 (필수 - 기본 기능)
1. Docker 볼륨 마운트 설정
2. 데이터베이스 스키마 설계 및 마이그레이션
3. 파일 파서 서비스 구현 (Type A)
4. Import Command 구현 (기본)
5. Recording 모델 생성
6. API 엔드포인트 구현 (목록, 상세, 재생)
7. 프론트엔드 연동 (기본)

### Phase 2 (중요 - 확장 기능)
8. 파일 파서 서비스 확장 (Type B)
9. JSON 파일 처리 (STT, 분석 결과)
10. 다운로드 API 구현
11. Range Requests 지원
12. 테스트 작성

### Phase 3 (선택 - 최적화)
13. 성능 최적화
14. 캐싱 전략
15. 상세 문서화

## 참고
- PRD: `/tasks/prd-demo-data-integration.md`
- Context: `/tasks/context-contraction.md`
- 기존 파일 시스템: `D:\IPX-Storage\FILES\VR_REC\YYYYMMDD\HH\`

