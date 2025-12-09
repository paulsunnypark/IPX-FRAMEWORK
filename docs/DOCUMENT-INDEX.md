# IPX-Framework 문서 인덱스

이 문서는 프로젝트의 모든 문서를 체계적으로 정리한 인덱스입니다.

## 📚 문서 분류

### 1. 시작하기 (Getting Started)

| 문서 | 설명 | 우선순위 |
| :-- | :-- | :-- |
| [README.md](../README.md) | 프로젝트 개요 및 빠른 시작 | ⭐⭐⭐ |
| [QUICKSTART.md](../QUICKSTART.md) | 빠른 시작 가이드 | ⭐⭐⭐ |
| [프로젝트 현황](system/project-status.md) | 전체 프로젝트 상태 요약 | ⭐⭐⭐ |

### 2. 개발 가이드 (Development Guides)

| 문서 | 설명 | 위치 |
| :-- | :-- | :-- |
| 개발 환경 구축 | 환경 설정 단계별 가이드 | `/guide/00-setup.md` |
| 개발 원칙 | Poly Vibe Coding Method 원칙 | `/guide/01-principles.md` |
| OpenSpec 가이드 | PRD 작성 방법 | `/guide/02-openspec.md` |
| 실행 가이드 | 작업 실행 워크플로우 | `/guide/03-execution.md` |
| 프레임워크 아키텍처 | IPX-Framework 상세 설계 | `/guide/ipx-framework.md` |
| PHP 설정 (Windows) | 로컬 PHP 설정 가이드 | `/guide/php-setup-existing.md` |

### 3. 데이터베이스 문서 (Database Documentation)

| 문서 | 설명 | 우선순위 |
| :-- | :-- | :-- |
| [접속 명세서](system/database-connection-spec.md) | 완전한 DB 접속 정보 | ⭐⭐⭐ |
| [아키텍처](system/database-architecture.md) | Multi-DB 구조 및 설계 | ⭐⭐ |
| [호환성 평가](system/mariadb-compatibility.md) | MariaDB 버전 호환성 | ⭐ |
| [요약 정보](system/mariadb-summary.md) | 핵심 정보 요약 | ⭐ |

### 4. 시스템 문서 (System Documentation)

| 문서 | 설명 | 우선순위 |
| :-- | :-- | :-- |
| [프로젝트 현황](system/project-status.md) | 전체 프로젝트 상태 요약 | ⭐⭐⭐ |
| [Monorepo 전환 가이드](system/monorepo-migration.md) | Monorepo 구조 전환 상세 내용 | ⭐⭐ |
| [프론트엔드 현황](system/frontend-status.md) | 프론트엔드 개발 상태 | ⭐⭐ |
| [포트 구성](system/port-configuration.md) | 포트 매핑 정보 | ⭐⭐ |
| [Windows Docker 최적화](system/windows-docker-volume-solution.md) | Windows Docker 환경 최적화 | ⭐ |
| [아키텍처 개요](system/architecture-overview.md) | 시스템 아키텍처 개요 | ⭐ |
| [프론트엔드 개발 가이드](system/frontend-development-guide.md) | 프론트엔드 개발 방법 | ⭐ |

### 5. 작업 관리 (Task Management)

| 문서 | 설명 | 위치 |
| :-- | :-- | :-- |
| Context Contraction | 상태 추적 로그 | `/tasks/context-contraction.md` |
| 데모 데이터 통합 PRD | 데모 데이터 통합 요구사항 | `/tasks/prd-demo-data-integration.md` |
| 데모 데이터 통합 작업 계획 | 데모 데이터 통합 작업 목록 | `/tasks/tasks-prd-demo-data-integration.md` |
| PRD 템플릿 | OpenSpec 작성 템플릿 | `/tasks/prd-template.md` |
| 작업 계획 템플릿 | 작업 계획 작성 템플릿 | `/tasks/tasks-template.md` |

### 6. 보고서 (Reports)

| 문서 | 설명 | 위치 |
| :-- | :-- | :-- |
| 중간 보고서 템플릿 | 중간 보고서 작성 템플릿 | `/docs/reports/interim-report-template.md` |
| 최종 보고서 템플릿 | 최종 보고서 작성 템플릿 | `/docs/reports/final-report-template.md` |

## 🗑️ 삭제된 문서 (중복 정리)

다음 문서들은 중복되거나 최신 정보와 불일치하여 삭제되었습니다:

- `SETUP-STATUS.md` → `QUICKSTART.md`로 통합
- `ENV-SETUP.md` → `docs/system/database-connection-spec.md`로 통합
- `MARIADB-SETUP.md` → `docs/system/database-connection-spec.md`로 통합
- `FRONTEND-SETUP.md` → `docs/system/frontend-status.md`로 통합
- `DATABASE-SETUP.md` → `docs/system/database-connection-spec.md`로 통합
- `docs/system/mariadb-runtime-info.md` → `database-connection-spec.md`로 통합
- `docs/system/mariadb-execution-summary.md` → `mariadb-summary.md`로 통합
- `docs/system/windows-docker-chmod-fix.md` → `windows-docker-volume-solution.md`로 통합
- `docs/system/windows-docker-optimization-summary.md` → `windows-docker-volume-solution.md`로 통합

## 📖 문서 읽기 순서

### 신규 개발자
1. [README.md](../README.md) - 프로젝트 개요
2. [프로젝트 현황](system/project-status.md) - 전체 프로젝트 상태
3. [QUICKSTART.md](../QUICKSTART.md) - 빠른 시작
4. [데이터베이스 접속 명세서](system/database-connection-spec.md) - DB 접속 정보
5. [개발 환경 구축](../../guide/00-setup.md) - 상세 설정 가이드

### 개발자 (기존)
1. [Context Contraction](../tasks/context-contraction.md) - 최신 상태 확인
2. [데이터베이스 접속 명세서](system/database-connection-spec.md) - DB 정보
3. [개발 가이드](../DEVELOPMENT.md) - 개발 워크플로우

### 아키텍트/설계자
1. [프레임워크 아키텍처](../guide/ipx-framework.md) - 전체 설계
2. [데이터베이스 아키텍처](system/database-architecture.md) - DB 설계
3. [개발 원칙](../guide/01-principles.md) - 개발 방법론

## 🔄 문서 업데이트 규칙

1. **시스템 변경 시**: 관련 문서 즉시 업데이트
2. **중복 발견 시**: 가장 최신 정보를 기준으로 통합
3. **템플릿 사용**: 새 문서 작성 시 기존 템플릿 활용
4. **버전 관리**: 중요한 변경사항은 날짜와 버전 표기

## 📝 문서 작성 가이드

- **명확성**: 누구나 이해할 수 있도록 작성
- **구조화**: 일관된 형식과 구조 유지
- **최신성**: 항상 최신 상태 유지
- **참조**: 관련 문서 간 상호 참조 링크 제공

---

**마지막 업데이트**: 2024-12-09 (Vite/Tailwind 설정 완료)

