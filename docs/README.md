# 문서 디렉토리

이 디렉토리는 프로젝트 진행 중 생성되는 **산출물 문서**를 저장합니다.

## 디렉토리 구조

```
/docs
├── README.md                    # 이 파일
├── user-manual/                 # 사용자 메뉴얼
│   ├── user-guide.md           # 사용자 가이드
│   └── admin-guide.md          # 관리자 가이드
├── system/                      # 시스템 문서
│   ├── architecture.md        # 시스템 아키텍처
│   ├── system-diagram.md       # 시스템 구성도
│   ├── deployment.md           # 배포 가이드
│   ├── database-connection-spec.md    # 데이터베이스 접속 명세서 ⭐
│   ├── database-architecture.md       # 데이터베이스 아키텍처 ⭐
│   ├── mariadb-compatibility.md       # MariaDB 호환성 평가
│   ├── mariadb-runtime-info.md        # MariaDB 실행 정보
│   └── mariadb-execution-summary.md   # MariaDB 실행 방식 요약
├── api/                         # API 문서
│   └── api-reference.md        # API 레퍼런스
└── reports/                     # 보고서
    ├── interim-report-*.md     # 중간 보고서
    └── final-report-*.md       # 최종 보고서
```

## 문서 분류

### 1. 사용자 메뉴얼 (`/docs/user-manual/`)
- 사용자 가이드: 일반 사용자를 위한 기능 설명서
- 관리자 가이드: 시스템 관리자를 위한 운영 매뉴얼

### 2. 시스템 문서 (`/docs/system/`)
- 시스템 아키텍처: 전체 시스템 구조 및 설계
- 시스템 구성도: 인프라 및 컴포넌트 다이어그램
- 배포 가이드: 프로덕션 환경 배포 절차
- **데이터베이스 접속 명세서**: DB 연결 정보 및 설정 가이드 ⭐
- **데이터베이스 아키텍처**: Multi-DB 구조 및 설계 원칙 ⭐

### 3. API 문서 (`/docs/api/`)
- API 레퍼런스: RESTful API 엔드포인트 상세 문서
- API 사용 예제: 클라이언트 통합 가이드

### 4. 보고서 (`/docs/reports/`)
- 중간 보고서: 프로젝트 진행 상황 보고서
- 최종 보고서: 프로젝트 완료 보고서

## 핵심 문서 (⭐)

### 데이터베이스 관련
- **[데이터베이스 접속 명세서](system/database-connection-spec.md)**: 
  - DBeaver, Cursor AI, Laravel 설정을 위한 완전한 DB 접속 정보
  - Multi-Database 구조 (ipx_master, ipx_vr)
  - 외부/내부 접속 프로필
  
- **[데이터베이스 아키텍처](system/database-architecture.md)**:
  - Multi-Database 설계 원칙
  - 테이블 구조 및 관계
  - Laravel 연동 방법

## 문서 작성 규칙

1. **명확성**: 누구나 이해할 수 있도록 명확하게 작성
2. **최신성**: 시스템 변경 시 문서도 함께 업데이트
3. **구조화**: 일관된 형식과 구조 유지
4. **버전 관리**: 중요한 변경사항은 버전 표기

## 참고

- **작업과제**: `/tasks` 디렉토리 참조
- **개발 가이드**: `/guide` 디렉토리 참조
