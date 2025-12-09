# MariaDB 요약 정보

이 문서는 MariaDB 관련 핵심 정보를 요약합니다. 상세 정보는 다른 문서를 참조하세요.

## 현재 사용 중인 MariaDB

### Docker MariaDB 컨테이너 (IPX-Framework 개발용)
- **버전**: MariaDB 10.11 (LTS)
- **컨테이너명**: `ipx-mariadb`
- **외부 포트**: `3307` (DBeaver 접속용)
- **내부 포트**: `3306` (Laravel 접속용)
- **Root 비밀번호**: `st5300!@#`
- **App 사용자**: `ipx_app` / `strong_password`

### 레거시 MariaDB 서비스 (참고용)
- **버전**: MariaDB 10.11.7
- **서비스명**: IPX-MariaDB
- **포트**: `3306`
- **실행 방식**: Windows 서비스
- **경로**: `D:\IPX-Storage\DATABASE\mariadb\`
- **상태**: 실행 중 (별도 용도)

**주의**: IPX-Framework는 Docker MariaDB 컨테이너를 사용합니다.

## 데이터베이스 구조

- **ipx_master**: 공통/인증 DB (SSO, 조직도, 권한)
- **ipx_vr**: 녹취 전용 DB (녹취 메타데이터, AI 분석)

## 상세 문서

- **[데이터베이스 접속 명세서](database-connection-spec.md)**: 완전한 접속 정보 및 설정 가이드
- **[데이터베이스 아키텍처](database-architecture.md)**: Multi-DB 구조 및 설계 원칙
- **[MariaDB 호환성 평가](mariadb-compatibility.md)**: 버전 호환성 정보

