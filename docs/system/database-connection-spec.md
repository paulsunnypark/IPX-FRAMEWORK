# New IPX-Framework 데이터베이스 접속 명세서

이 문서는 향후 **Cursor AI에게 Context로 제공**하거나, **Laravel `.env` 설정**, **동료 개발자 공유** 시 기준으로 사용합니다.

---

## 1. 기본 접속 정보 (Overview)

이 데이터베이스는 **Docker 컨테이너** 기반으로 구동되며, 기존 레거시 시스템과 격리된 **3307 포트**를 사용합니다.

| 항목 | 상세 내용 | 비고 |
| :-- | :-- | :-- |
| **DBMS** | **MariaDB 10.11 (LTS)** | JSON, CTE 지원 필수 버전 |
| **Container Name** | `ipx-mariadb` | `docker-compose.yml` 서비스명 |
| **Timezone** | `Asia/Seoul` | KST |
| **Encoding** | `utf8mb4_unicode_ci` | 이모지/다국어 지원 |

---

## 2. 접속 프로필 (Connection Profiles)

### A. 외부 접속용 (LocalHost / DBeaver / Cursor)

개발자 PC(로컬)에서 DB 관리 도구로 접속할 때 사용하는 정보입니다.

- **Host:** `127.0.0.1` (localhost)
- **Port:** **`3307`** (주의: 3306 아님)
- **User (Admin):** `root`
- **Password:** `st5300!@#`
- **User (App):** `ipx_app`
- **Password:** `strong_password` (SQL 스크립트에서 설정한 값)

### B. 내부 접속용 (Docker Internal / Laravel)

Laravel 컨테이너(`ipx-php`) 내부에서 DB에 접속할 때 사용하는 정보입니다.

- **Host:** **`mariadb`** (Docker Service Name)
- **Port:** **`3306`** (컨테이너 내부 포트)
- **User:** `ipx_app`
- **Password:** `strong_password`

---

## 3. 데이터베이스 구성 (Database Schema)

시스템은 **Multi-Database** 아키텍처를 따르며, 두 개의 데이터베이스로 나뉩니다.

### ① `ipx_master` (공통/인증 DB)

- **역할:** 통합 인증(SSO), 조직도 관리, 공통 코드, 시스템 전역 권한 관리.
- **주요 테이블:**
  - `users`: 통합 사용자 정보
  - `departments`: 조직도/부서 정보
  - `product_permissions`: 제품별 접근 권한 (VR, IVR, NMS 등)

### ② `ipx_vr` (녹취 전용 DB)

- **역할:** 녹취 시스템의 비즈니스 로직 및 대용량 데이터 저장.
- **주요 테이블:**
  - `servers`: 녹취 서버 및 STT 엔진 서버 정보
  - `channels`: 내선 번호 매핑 정보
  - `recordings`: 녹취 원본 메타데이터 (핵심)
  - `analyses`: AI 분석 결과 (JSON 저장)

---

## 4. Laravel 환경 설정 가이드 (.env)

Laravel 설치 시 `.env` 파일에 아래 내용을 설정합니다. (멀티 DB 설정)

```ini
# -------------------------------------------
# [Database 1] Master DB (SSO/Auth)
# -------------------------------------------
DB_CONNECTION=mysql_master
DB_MASTER_HOST=mariadb        # Docker Service Name
DB_MASTER_PORT=3306           # Internal Port
DB_MASTER_DATABASE=ipx_master
DB_MASTER_USERNAME=ipx_app
DB_MASTER_PASSWORD=strong_password

# -------------------------------------------
# [Database 2] VR Product DB (Recording/AI)
# -------------------------------------------
DB_VR_HOST=mariadb
DB_VR_PORT=3306
DB_VR_DATABASE=ipx_vr
DB_VR_USERNAME=ipx_app
DB_VR_PASSWORD=strong_password
```

---

## 5. DBeaver 연결 설정

### 연결 프로필 생성

1. **새 연결 생성** → **MariaDB** 선택
2. **Main 탭:**
   - Server Host: `127.0.0.1`
   - Port: `3307`
   - Database: `ipx_master` 또는 `ipx_vr`
   - Username: `root` (관리자) 또는 `ipx_app` (애플리케이션)
   - Password: `st5300!@#` 또는 `strong_password`
3. **Driver Properties:**
   - `useSSL`: `false` (로컬 개발 환경)
   - `allowPublicKeyRetrieval`: `true`

### 연결 테스트

```sql
-- 데이터베이스 목록 확인
SHOW DATABASES;

-- 현재 데이터베이스 확인
SELECT DATABASE();

-- 사용자 권한 확인
SHOW GRANTS FOR 'ipx_app'@'%';
```

---

## 6. 데이터베이스 초기화 스크립트

### 데이터베이스 및 사용자 생성

```sql
-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS `ipx_master` 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `ipx_vr` 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

-- 애플리케이션 사용자 생성
CREATE USER IF NOT EXISTS 'ipx_app'@'%' IDENTIFIED BY 'strong_password';

-- 권한 부여
GRANT ALL PRIVILEGES ON `ipx_master`.* TO 'ipx_app'@'%';
GRANT ALL PRIVILEGES ON `ipx_vr`.* TO 'ipx_app'@'%';

-- 권한 적용
FLUSH PRIVILEGES;
```

---

## 7. Laravel Multi-Database 설정

### config/database.php 설정

```php
'connections' => [
    'mysql_master' => [
        'driver' => 'mysql',
        'host' => env('DB_MASTER_HOST', 'mariadb'),
        'port' => env('DB_MASTER_PORT', '3306'),
        'database' => env('DB_MASTER_DATABASE', 'ipx_master'),
        'username' => env('DB_MASTER_USERNAME', 'ipx_app'),
        'password' => env('DB_MASTER_PASSWORD', 'strong_password'),
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
    ],
    
    'mysql_vr' => [
        'driver' => 'mysql',
        'host' => env('DB_VR_HOST', 'mariadb'),
        'port' => env('DB_VR_PORT', '3306'),
        'database' => env('DB_VR_DATABASE', 'ipx_vr'),
        'username' => env('DB_VR_USERNAME', 'ipx_app'),
        'password' => env('DB_VR_PASSWORD', 'strong_password'),
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
    ],
],
```

### 모델에서 사용

```php
// Master DB 사용
$users = DB::connection('mysql_master')->table('users')->get();

// VR DB 사용
$recordings = DB::connection('mysql_vr')->table('recordings')->get();

// Eloquent Model에서 지정
class Recording extends Model
{
    protected $connection = 'mysql_vr';
}
```

---

## 8. 포트 매핑 정리

| 용도 | 호스트 포트 | 컨테이너 포트 | 설명 |
| :-- | :-- | :-- | :-- |
| **외부 접속** | `3307` | `3306` | DBeaver, 로컬 개발 도구 |
| **내부 접속** | - | `3306` | Laravel 컨테이너 내부 |
| **레거시 MariaDB** | `3306` | - | 기존 Windows 서비스 (별도) |

---

## 9. 문제 해결

### 연결 실패 시

1. **Docker 컨테이너 상태 확인**
   ```bash
   docker-compose ps
   docker-compose logs mariadb
   ```

2. **포트 충돌 확인**
   ```powershell
   netstat -ano | findstr :3307
   ```

3. **방화벽 확인**
   - Windows 방화벽에서 3307 포트 허용 확인

### 권한 오류 시

```sql
-- 사용자 권한 재부여
GRANT ALL PRIVILEGES ON `ipx_master`.* TO 'ipx_app'@'%';
GRANT ALL PRIVILEGES ON `ipx_vr`.* TO 'ipx_app'@'%';
FLUSH PRIVILEGES;
```

---

## 10. 참고 문서

- [MariaDB 호환성 평가](mariadb-compatibility.md)
- [MariaDB 실행 정보](mariadb-runtime-info.md)
- [MariaDB 실행 방식 요약](mariadb-execution-summary.md)
- [Docker Compose 설정](../docker-compose.yml)

---

**마지막 업데이트**: 2024-12-XX

