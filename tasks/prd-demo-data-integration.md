# PRD – 데모 데이터 통합 (Demo Data Integration)

## One Goal
기존 IPX-VR 시스템의 데모용 음성 데이터(파일 시스템)를 New-IPX-Framework의 데이터베이스로 자동 동기화하고, 웹 인터페이스를 통해 재생 및 다운로드할 수 있도록 구현한다.

---

## System Context
- **Framework**: Laravel 11 + Vue 3
- **Infrastructure**: Docker (Nginx + PHP-FPM + MariaDB + Redis)
- **Storage**: Windows 호스트 파일 시스템 (`D:\IPX-Storage\FILES\VR_REC`) → Docker Volume 마운트
- **API**: RESTful JSON API
- **Database**: `ipx_vr` (녹취 전용 DB)

### 주요 컴포넌트
- **Import Command**: 파일 시스템 스캔 및 DB 동기화 (`app/Console/Commands/ImportDemoFiles.php`)
- **Recording Model**: 녹취 메타데이터 관리 (`app/Models/Recording.php`)
- **Recording Controller**: 재생/다운로드 API (`app/Http/Controllers/Api/RecordingController.php`)
- **File Parser Service**: 파일명 파싱 로직 (`app/Services/FileParserService.php`)
- **Storage Service**: 파일 접근 및 스트리밍 (`app/Services/StorageService.php`)

### 데이터 흐름
```
[Windows File System]
    D:\IPX-Storage\FILES\VR_REC\YYYYMMDD\HH\*.wav
         ↓ (Docker Volume Mount)
[Container File System]
    /var/www/recordings_root/YYYYMMDD/HH/*.wav
         ↓ (Import Command)
[Database]
    ipx_vr.recordings (메타데이터)
         ↓ (API Request)
[Frontend]
    Vue.js SPA (재생/다운로드)
```

---

## Acceptance Criteria

### 정상 조건
- [ ] Docker 볼륨 마운트가 정상적으로 작동하여 컨테이너 내부에서 Windows 파일 시스템 접근 가능
- [ ] `php artisan ipx:import-demo` 명령어로 파일 시스템의 모든 `.wav` 파일을 스캔하여 DB에 등록
- [ ] 파일명 패턴(Type A: `YYYYMMDDHHMMSS_PHONE_EXT_*_*.wav`)을 정확히 파싱하여 메타데이터 추출
- [ ] 관련 JSON 파일(`*_asr.json`, `*_cvt.json`)이 존재하면 함께 처리
- [ ] 중복 등록 방지 (파일명 기준으로 기존 레코드 확인)
- [ ] API `/api/v1/recordings`로 녹취 목록 조회 가능
- [ ] API `/api/v1/recordings/{id}/play`로 음성 파일 스트리밍 재생 가능 (Range Requests 지원)
- [ ] API `/api/v1/recordings/{id}/download`로 파일 다운로드 가능
- [ ] 프론트엔드 `/inquiry` 페이지에서 실제 DB 데이터 표시
- [ ] 프론트엔드에서 재생 버튼 클릭 시 음성 파일 재생 가능

### 오류 조건
- [ ] 파일이 존재하지 않을 경우 404 응답
- [ ] 파일 읽기 권한이 없을 경우 403 응답
- [ ] 잘못된 파일명 패턴일 경우 파싱 오류 로그 기록 및 스킵
- [ ] DB 연결 실패 시 명확한 오류 메시지 출력
- [ ] 파일 시스템 접근 실패 시 명확한 오류 메시지 출력

### 경계 조건
- [ ] 대용량 파일(100MB 이상) 스트리밍 시 메모리 효율적 처리
- [ ] 동시 다중 요청 시 성능 저하 없음
- [ ] 파일명에 특수문자 포함 시 안전하게 처리
- [ ] 날짜 형식이 잘못된 경우(예: `20231299`) 파싱 오류 처리

### 보안 조건
- [ ] 인증된 사용자만 파일 접근 가능 (Laravel Sanctum)
- [ ] 파일 경로 조작 공격 방지 (Path Traversal 방지)
- [ ] 직접 파일 시스템 접근 차단 (Nginx에서 `/recordings` 경로 차단)
- [ ] 파일 다운로드 시 적절한 Content-Type 헤더 설정

---

## Contracts

### API 엔드포인트
```
GET    /api/v1/recordings              # 녹취 목록 조회 (페이징, 필터링)
GET    /api/v1/recordings/{id}          # 녹취 상세 조회
GET    /api/v1/recordings/{id}/play    # 음성 파일 스트리밍 재생 (Range Requests 지원)
GET    /api/v1/recordings/{id}/download # 파일 다운로드
POST   /api/v1/recordings/import       # 수동 Import 트리거 (관리자용)
```

### Request DTO 구조
```php
// 녹취 목록 조회 요청
class RecordingListRequest extends Data
{
    public function __construct(
        public ?string $start_date = null,
        public ?string $end_date = null,
        public ?string $customer_number = null,
        public ?string $user_name = null,
        public ?string $call_type = null, // 'incoming' | 'outgoing'
        public ?string $conversion_status = null,
        public int $page = 1,
        public int $per_page = 15,
    ) {}
}

// Import 요청
class ImportRequest extends Data
{
    public function __construct(
        public ?string $path = null, // 특정 경로만 스캔 (null이면 전체)
        public bool $force = false,  // 중복 파일도 재등록
    ) {}
}
```

### Response DTO 구조
```php
// 녹취 목록 응답
class RecordingListResponse extends Data
{
    public function __construct(
        public array $data, // RecordingResponse[]
        public int $total,
        public int $page,
        public int $per_page,
        public int $last_page,
    ) {}
}

// 녹취 상세 응답
class RecordingResponse extends Data
{
    public function __construct(
        public int $id,
        public string $file_name,
        public string $file_path,
        public Carbon $start_time,
        public ?Carbon $end_time,
        public int $duration, // 초 단위
        public string $remote_party, // 고객 번호
        public string $local_party,   // 내선 번호
        public ?string $user_name,
        public ?string $department,
        public bool $has_stt,
        public bool $has_analysis,
        public ?string $play_url,
        public ?string $download_url,
        public Carbon $created_at,
    ) {}
}
```

### DB Schema
```sql
-- ipx_vr.recordings 테이블
CREATE TABLE recordings (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    server_id BIGINT UNSIGNED NULL,
    channel_id BIGINT UNSIGNED NULL,
    file_path VARCHAR(500) NOT NULL COMMENT '상대 경로 (예: /20231215/09)',
    file_name VARCHAR(255) NOT NULL COMMENT '파일명 (예: 20231215095859_0335907400_3620_0_001.wav)',
    file_size BIGINT UNSIGNED NULL COMMENT '파일 크기 (bytes)',
    start_time DATETIME NOT NULL COMMENT '녹취 시작 시간',
    end_time DATETIME NULL COMMENT '녹취 종료 시간',
    duration INT UNSIGNED NULL COMMENT '녹취 시간 (초)',
    remote_party VARCHAR(50) NULL COMMENT '고객 번호',
    local_party VARCHAR(50) NULL COMMENT '내선 번호/사용자 ID',
    user_id BIGINT UNSIGNED NULL COMMENT '사용자 ID (ipx_master.users 참조)',
    department_id BIGINT UNSIGNED NULL COMMENT '부서 ID (ipx_master.departments 참조)',
    call_type ENUM('incoming', 'outgoing') NULL COMMENT '수신/발신',
    has_stt BOOLEAN DEFAULT FALSE COMMENT 'STT 변환 여부',
    has_analysis BOOLEAN DEFAULT FALSE COMMENT 'AI 분석 여부',
    status ENUM('pending', 'processing', 'completed', 'failed') DEFAULT 'completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_file_name (file_name),
    INDEX idx_start_time (start_time),
    INDEX idx_remote_party (remote_party),
    INDEX idx_local_party (local_party),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ipx_vr.transcriptions 테이블 (STT 결과)
CREATE TABLE transcriptions (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    recording_id BIGINT UNSIGNED NOT NULL,
    full_text TEXT NULL COMMENT '전체 텍스트',
    segments JSON NULL COMMENT '세그먼트별 텍스트 (시간 정보 포함)',
    confidence_score DECIMAL(5,2) NULL COMMENT '신뢰도 점수',
    status ENUM('pending', 'processing', 'completed', 'failed') DEFAULT 'completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (recording_id) REFERENCES recordings(id) ON DELETE CASCADE,
    INDEX idx_recording_id (recording_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ipx_vr.analyses 테이블 (AI 분석 결과)
CREATE TABLE analyses (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    recording_id BIGINT UNSIGNED NOT NULL,
    analysis_type VARCHAR(50) NOT NULL COMMENT '분석 타입 (summary, sentiment, keywords 등)',
    result_data JSON NOT NULL COMMENT '분석 결과 데이터',
    confidence_score DECIMAL(5,2) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (recording_id) REFERENCES recordings(id) ON DELETE CASCADE,
    INDEX idx_recording_id (recording_id),
    INDEX idx_analysis_type (analysis_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Event 구조
```php
// 녹취 파일 Import 완료 이벤트
class RecordingImported
{
    public function __construct(
        public Recording $recording,
        public int $totalImported,
    ) {}
}

// STT 변환 완료 이벤트
class TranscriptionCompleted
{
    public function __construct(
        public Recording $recording,
        public Transcription $transcription,
    ) {}
}
```

---

## Risk & Assumption

### 리스크
- [ ] **리스크 1**: Windows 파일 경로와 Linux 컨테이너 경로 불일치
  - **대응**: Docker Volume 마운트 시 절대 경로 사용, 경로 변환 로직 구현
- [ ] **리스크 2**: 대용량 파일 스캔 시 메모리 부족
  - **대응**: 청크 단위 스캔, Generator 패턴 사용
- [ ] **리스크 3**: 파일명 패턴이 일관되지 않음 (Type A, Type B 등)
  - **대응**: 다중 파서 전략 패턴 적용, 확장 가능한 파서 구조
- [ ] **리스크 4**: 동시 다중 사용자 접근 시 파일 시스템 부하
  - **대응**: 파일 캐싱, CDN 또는 별도 스토리지 서버 고려

### 미해결 이슈
- [ ] 파일명 패턴 Type B (`M_20231116213558376_043_2201.wav`) 파싱 로직 미정
- [ ] 파일 크기 및 duration 계산 방법 (WAV 파일 헤더 파싱 필요 여부)
- [ ] 사용자 ID 매핑 로직 (내선 번호 → 사용자 ID)

### 가정 (Assumption)
- Windows 호스트의 `D:\IPX-Storage\FILES\VR_REC` 경로가 항상 접근 가능
- 파일명 패턴이 대부분 Type A 형식을 따름
- JSON 파일(`*_asr.json`, `*_cvt.json`)이 항상 `.wav` 파일과 같은 디렉토리에 위치
- 파일 시스템 구조가 `YYYYMMDD/HH` 형식을 유지

---

## Done Definition

### 테스트 조건
- [ ] Unit Test: FileParserService 파싱 로직 테스트 커버리지 90% 이상
- [ ] Unit Test: StorageService 파일 접근 로직 테스트
- [ ] Integration Test: Import Command 전체 플로우 테스트
- [ ] Feature Test: API 엔드포인트 테스트 (재생, 다운로드)
- [ ] Feature Test: Range Requests 지원 확인

### 성능 조건
- [ ] Import Command: 1000개 파일 처리 시간 5분 이내
- [ ] API 응답 시간: 목록 조회 평균 200ms 이하
- [ ] 파일 스트리밍: 초기 버퍼링 1초 이내
- [ ] 동시 접근: 10명 이상 동시 재생 가능

### 로그 조건
- [ ] Import Command 실행 시 상세 진행 상황 로그 출력
- [ ] 파일 접근 실패 시 오류 로그 기록
- [ ] API 요청/응답 로깅 (민감 정보 제외)
- [ ] 파일 다운로드 통계 로깅

---

## 참고 자료
- 기존 IPX-VR 시스템 파일 저장 구조
- Docker Volume 마운트 문서: [Docker Docs](https://docs.docker.com/storage/volumes/)
- Laravel Storage Facade: [Laravel Docs](https://laravel.com/docs/11.x/filesystem)
- HTTP Range Requests: [RFC 7233](https://tools.ietf.org/html/rfc7233)

