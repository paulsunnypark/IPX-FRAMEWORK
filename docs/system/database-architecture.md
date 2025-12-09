# IPX-Framework 데이터베이스 아키텍처

## 개요

IPX-Framework는 **Multi-Database 아키텍처**를 채택하여 시스템의 확장성과 유지보수성을 향상시킵니다.

---

## 데이터베이스 구조

### ① `ipx_master` (공통/인증 DB)

**역할**: 시스템 전역 공통 데이터 및 인증 관리

#### 주요 기능
- 통합 인증(SSO)
- 조직도/부서 관리
- 공통 코드 관리
- 제품별 접근 권한 관리
- 사용자 전역 정보

#### 주요 테이블 (예상)
```sql
-- 사용자 정보
users
  - id
  - username
  - email
  - password_hash
  - department_id
  - created_at
  - updated_at

-- 조직도/부서
departments
  - id
  - name
  - parent_id
  - level
  - created_at

-- 제품별 권한
product_permissions
  - id
  - user_id
  - product_type (VR, IVR, NMS 등)
  - permission_level
  - created_at
```

### ② `ipx_vr` (녹취 전용 DB)

**역할**: 녹취 시스템의 비즈니스 로직 및 대용량 데이터 저장

#### 주요 기능
- 녹취 메타데이터 관리
- STT 엔진 서버 정보
- 내선 번호 매핑
- AI 분석 결과 저장 (JSON)
- 통계 데이터

#### 주요 테이블 (예상)
```sql
-- 녹취 서버 정보
servers
  - id
  - name
  - ip_address
  - port
  - server_type (recording, stt)
  - status
  - created_at

-- 내선 번호 매핑
channels
  - id
  - extension_number
  - server_id
  - department_id
  - created_at

-- 녹취 메타데이터
recordings
  - id
  - channel_id
  - call_id
  - start_time
  - duration
  - file_path
  - file_size
  - status (pending, processing, completed)
  - created_at
  - updated_at

-- AI 분석 결과
analyses
  - id
  - recording_id
  - analysis_type (stt, sentiment, summary 등)
  - result_data (JSON)
  - confidence_score
  - created_at
  - updated_at
```

---

## 아키텍처 설계 원칙

### 1. 관심사 분리 (Separation of Concerns)
- **Master DB**: 인증, 권한, 조직 등 공통 관심사
- **VR DB**: 녹취 시스템 전용 비즈니스 로직

### 2. 확장성 (Scalability)
- 제품별 독립적인 데이터베이스로 확장 가능
- 향후 IVR, NMS 등 추가 제품 DB 분리 용이

### 3. 성능 최적화
- 제품별 데이터베이스 분리로 쿼리 성능 향상
- 인덱스 최적화가 제품별로 독립적으로 가능

### 4. 유지보수성
- 제품별 스키마 변경이 다른 제품에 영향 없음
- 백업/복구 전략을 제품별로 독립적으로 수립 가능

---

## 데이터베이스 연결 전략

### Laravel에서의 사용

#### 1. 기본 연결 설정
```php
// config/database.php
'connections' => [
    'mysql_master' => [...],
    'mysql_vr' => [...],
],
```

#### 2. 모델별 연결 지정
```php
// Master DB 사용
class User extends Model
{
    protected $connection = 'mysql_master';
}

// VR DB 사용
class Recording extends Model
{
    protected $connection = 'mysql_vr';
}
```

#### 3. 쿼리 빌더 사용
```php
// Master DB
$users = DB::connection('mysql_master')
    ->table('users')
    ->get();

// VR DB
$recordings = DB::connection('mysql_vr')
    ->table('recordings')
    ->get();
```

---

## 데이터베이스 관계 관리

### Cross-Database 관계

Master DB의 `users`와 VR DB의 `recordings` 간 관계는 애플리케이션 레벨에서 관리:

```php
// User 모델 (Master DB)
class User extends Model
{
    protected $connection = 'mysql_master';
    
    // 애플리케이션 레벨 관계
    public function recordings()
    {
        return DB::connection('mysql_vr')
            ->table('recordings')
            ->where('user_id', $this->id)
            ->get();
    }
}
```

---

## 마이그레이션 전략

### 제품별 마이그레이션 분리

```
database/
├── migrations/
│   ├── master/
│   │   ├── 2024_01_01_000001_create_users_table.php
│   │   ├── 2024_01_01_000002_create_departments_table.php
│   │   └── ...
│   └── vr/
│       ├── 2024_01_01_100001_create_servers_table.php
│       ├── 2024_01_01_100002_create_recordings_table.php
│       └── ...
```

### 마이그레이션 실행

```bash
# Master DB 마이그레이션
php artisan migrate --database=mysql_master --path=database/migrations/master

# VR DB 마이그레이션
php artisan migrate --database=mysql_vr --path=database/migrations/vr
```

---

## 백업 전략

### 제품별 독립 백업

```bash
# Master DB 백업
mysqldump -h 127.0.0.1 -P 3307 -u root -p ipx_master > backup_master.sql

# VR DB 백업
mysqldump -h 127.0.0.1 -P 3307 -u root -p ipx_vr > backup_vr.sql
```

---

## 향후 확장 계획

### 추가 제품 데이터베이스

- `ipx_ivr`: IVR 시스템 전용
- `ipx_nms`: 네트워크 관리 시스템 전용
- `ipx_analytics`: 통계/분석 전용

각 제품은 독립적인 데이터베이스로 운영되며, Master DB를 통해 통합 인증 및 권한 관리가 이루어집니다.

---

## 참고 문서

- [데이터베이스 접속 명세서](database-connection-spec.md)
- [MariaDB 호환성 평가](mariadb-compatibility.md)
- [MariaDB 실행 정보](mariadb-runtime-info.md)

