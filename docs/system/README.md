# 시스템 문서 디렉토리

이 디렉토리는 시스템 아키텍처, 데이터베이스, 배포 관련 문서를 저장합니다.

## 문서 구조

```
/system
├── README.md                    # 이 파일
├── architecture-template.md     # 시스템 아키텍처 템플릿
├── system-diagram-template.md   # 시스템 구성도 템플릿
├── database-connection-spec.md   # 데이터베이스 접속 명세서 ⭐
├── database-architecture.md     # 데이터베이스 아키텍처 ⭐
├── mariadb-compatibility.md     # MariaDB 호환성 평가
└── mariadb-summary.md           # MariaDB 요약 정보
```

## 핵심 문서 (⭐)

### 데이터베이스 관련

1. **[데이터베이스 접속 명세서](database-connection-spec.md)**
   - DBeaver, Cursor AI, Laravel 설정을 위한 완전한 DB 접속 정보
   - Multi-Database 구조 (ipx_master, ipx_vr)
   - 외부/내부 접속 프로필
   - **가장 중요**: 개발 시 항상 참조

2. **[데이터베이스 아키텍처](database-architecture.md)**
   - Multi-Database 설계 원칙
   - 테이블 구조 및 관계
   - Laravel 연동 방법
   - 마이그레이션 전략

3. **[MariaDB 호환성 평가](mariadb-compatibility.md)**
   - 버전 호환성 정보
   - 기능 지원 확인
   - Laravel 11 호환성

4. **[MariaDB 요약 정보](mariadb-summary.md)**
   - 핵심 정보 요약
   - 빠른 참조용

## 템플릿 문서

- `architecture-template.md`: 시스템 아키텍처 문서 작성 템플릿
- `system-diagram-template.md`: 시스템 구성도 작성 템플릿

## 문서 작성 규칙

1. **명확성**: 누구나 이해할 수 있도록 명확하게 작성
2. **최신성**: 시스템 변경 시 문서도 함께 업데이트
3. **구조화**: 일관된 형식과 구조 유지
4. **버전 관리**: 중요한 변경사항은 버전 표기

## 참고

- **작업과제**: `/tasks` 디렉토리 참조
- **개발 가이드**: `/guide` 디렉토리 참조
- **루트 문서**: `DATABASE-SETUP.md` (빠른 시작)

