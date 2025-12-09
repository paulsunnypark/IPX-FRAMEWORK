# PRD – <project-name>

## One Goal
단일 명확한 목표 정의

예: "통화 녹취 파일을 STT 변환하고 AI 분석하여 대시보드에 표시하는 기능 구현"

---

## System Context
- **Framework**: Laravel 11 + Vue 3
- **Infrastructure**: Docker (Nginx + PHP-FPM + MySQL + Redis)
- **API**: RESTful JSON API
- **Queue**: Redis Queue (비동기 작업 처리)

### 주요 컴포넌트
- [컴포넌트 1]: 역할 설명
- [컴포넌트 2]: 역할 설명

### 데이터 흐름
```
[Frontend] → [API] → [Service] → [Job/Queue] → [Database]
                ↓
            [Response]
```

---

## Acceptance Criteria

### 정상 조건
- [ ] 조건 1
- [ ] 조건 2

### 오류 조건
- [ ] 오류 처리 1
- [ ] 오류 처리 2

### 경계 조건
- [ ] 경계 케이스 1
- [ ] 경계 케이스 2

### 보안 조건
- [ ] 인증/인가 검증
- [ ] 입력 검증
- [ ] SQL Injection 방지

---

## Contracts

### API 엔드포인트
```
GET    /api/v1/resource          # 목록 조회
GET    /api/v1/resource/{id}     # 상세 조회
POST   /api/v1/resource          # 생성
PUT    /api/v1/resource/{id}     # 수정
DELETE /api/v1/resource/{id}     # 삭제
```

### DTO 구조
```php
// Request DTO
class CreateResourceRequest extends Data
{
    public function __construct(
        public string $name,
        public ?string $description = null,
    ) {}
}

// Response DTO
class ResourceResponse extends Data
{
    public function __construct(
        public int $id,
        public string $name,
        public string $status,
        public Carbon $created_at,
    ) {}
}
```

### DB Schema
```sql
CREATE TABLE resources (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('pending', 'processing', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    INDEX idx_status (status)
);
```

### Event 구조
```php
class ResourceCreated
{
    public function __construct(
        public Resource $resource
    ) {}
}
```

---

## Risk & Assumption

### 리스크
- [ ] 리스크 1: 설명 및 대응 방안
- [ ] 리스크 2: 설명 및 대응 방안

### 미해결 이슈
- [ ] 이슈 1: 설명
- [ ] 이슈 2: 설명

### 가정 (Assumption)
- 가정 1: 설명
- 가정 2: 설명

---

## Done Definition

### 테스트 조건
- [ ] Unit Test: Service 로직 테스트 커버리지 80% 이상
- [ ] Integration Test: API 엔드포인트 테스트
- [ ] Feature Test: 주요 시나리오 테스트

### 성능 조건
- [ ] API 응답 시간: 평균 200ms 이하
- [ ] 동시 처리: 100 req/s 이상
- [ ] Queue 처리: 평균 5초 이내

### 로그 조건
- [ ] 모든 API 요청/응답 로깅
- [ ] 오류 발생 시 상세 로그 기록
- [ ] Queue 작업 상태 추적

---

## 참고 자료
- 관련 문서 링크
- 기존 코드 참조
- 외부 API 문서

