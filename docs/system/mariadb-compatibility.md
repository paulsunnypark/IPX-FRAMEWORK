# MariaDB 호환성 평가

## 현재 상태

### MariaDB 버전
- **버전**: MariaDB 10.11.7
- **상태**: ✅ 실행 중
- **서비스명**: IPX-MariaDB

### 기능 지원 확인

| 기능 | 지원 여부 | 비고 |
|------|----------|------|
| JSON 지원 | ✅ | IPX-Framework 요구사항 충족 |
| CTE (Common Table Expression) | ✅ | 통계 쿼리 최적화 가능 |
| Window Functions | ⚠️ | 일부 제한 가능 (대부분의 경우 문제 없음) |

## 호환성 평가

### ✅ IPX-Framework 요구사항 충족

**요구사항**: MySQL 8.0+ 또는 MariaDB 10.3+
**현재 버전**: MariaDB 10.11.7

**결론**: ✅ **완전 호환 가능**

### Laravel 11 호환성

Laravel 11은 MariaDB 10.3+를 공식 지원합니다:
- ✅ Eloquent ORM 완전 지원
- ✅ 마이그레이션 시스템 지원
- ✅ JSON 컬럼 타입 지원
- ✅ CTE 쿼리 지원

### IPX-Framework 기능 호환성

#### 1. JSON 컬럼 타입
```sql
-- 비정형 AI 데이터 저장 가능
CREATE TABLE analysis_results (
    id BIGINT PRIMARY KEY,
    data JSON,
    created_at TIMESTAMP
);
```
✅ **완전 지원**

#### 2. CTE (Common Table Expression)
```sql
-- 통계 쿼리 최적화
WITH stats AS (
    SELECT COUNT(*) as total FROM calls
)
SELECT * FROM stats;
```
✅ **완전 지원**

#### 3. Window Functions
MariaDB 10.2+에서 Window Functions를 지원하지만, 일부 고급 기능은 제한될 수 있습니다.
⚠️ **대부분의 경우 문제 없음** (필요 시 MySQL 8.0 문법으로 대체 가능)

## 개발 환경 설정

### .env 설정 (Multi-Database)

자세한 내용은 [데이터베이스 접속 명세서](database-connection-spec.md)를 참조하세요.

### 현재 사용 중인 MariaDB

IPX-Framework는 **Docker MariaDB 컨테이너**를 사용합니다:
- 외부 접속: `127.0.0.1:3307`
- 내부 접속: `mariadb:3306`

레거시 Windows 서비스 MariaDB는 별도 용도로 사용 중입니다.

### Laravel 설정 확인

Laravel은 MariaDB를 MySQL 드라이버로 인식하므로 추가 설정 불필요:
- `config/database.php`에서 `mysql` 연결 사용
- Eloquent ORM 자동 호환

## 주의사항

### 1. Window Functions 제한
일부 복잡한 Window Functions는 MySQL 8.0과 다를 수 있습니다.
- **대응**: 필요 시 쿼리를 MariaDB 문법에 맞게 조정

### 2. 성능 최적화
MariaDB 10.11은 MySQL 8.0과 유사한 성능을 제공하지만, 일부 최적화 옵션이 다를 수 있습니다.
- **대응**: MariaDB 전용 최적화 옵션 활용

### 3. 마이그레이션 호환성
Laravel 마이그레이션은 대부분 호환되지만, 일부 고급 기능은 확인 필요:
- **대응**: 마이그레이션 테스트 후 조정

## 권장사항

### ✅ MariaDB 사용 권장

1. **완전 호환**: IPX-Framework 요구사항 충족
2. **안정성**: MariaDB 10.11은 안정적인 LTS 버전
3. **기능**: JSON, CTE 등 필수 기능 모두 지원
4. **성능**: MySQL 8.0과 유사한 성능

### 개발 진행 계획

1. ✅ MariaDB 10.11.7 사용 결정
2. ✅ .env 파일에 MariaDB 연결 정보 설정
3. ✅ Laravel 프로젝트 초기화 시 MariaDB 사용
4. ⚠️ Window Functions 사용 시 MariaDB 문법 확인

## 결론

**MariaDB 10.11.7은 IPX-Framework 개발에 적합합니다.**

- ✅ 버전 요구사항 충족 (10.3+)
- ✅ 필수 기능 모두 지원 (JSON, CTE)
- ✅ Laravel 11 완전 호환
- ⚠️ Window Functions 일부 제한 (대부분의 경우 문제 없음)

**개발 진행 가능**: ✅

