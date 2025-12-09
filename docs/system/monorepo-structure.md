# Monorepo 구조 가이드

**작성일**: 2024-12-09

## 개요

IPX-Framework는 Monorepo 구조를 채택하여 여러 애플리케이션을 단일 리포지토리에서 관리합니다.

## 디렉토리 구조

```
/ipx-framework
├── apps/                    # 애플리케이션 디렉토리
│   └── ipx-vr/             # VR 애플리케이션 (Laravel)
│       ├── app/
│       ├── bootstrap/
│       ├── config/
│       ├── database/
│       ├── public/
│       ├── resources/
│       ├── routes/
│       ├── storage/
│       └── ...
├── docker/                  # 인프라 설정 (공통)
│   ├── nginx/
│   ├── php/
│   └── mariadb/
├── tasks/                   # 작업 관리 문서
│   ├── prd-*.md
│   ├── tasks-prd-*.md
│   └── context-contraction.md
└── docs/                    # 산출물 문서
    ├── system/
    ├── api/
    └── reports/
```

## 애플리케이션 추가 방법

향후 새로운 애플리케이션을 추가할 때:

1. `apps/` 디렉토리에 새 폴더 생성 (예: `apps/ipx-ivr/`)
2. `docker-compose.yml`에 새 서비스 추가 (필요 시)
3. Nginx 설정에 새 애플리케이션 라우팅 추가

## 개발 워크플로우

### VR 애플리케이션 개발

```bash
# 1. 애플리케이션 디렉토리로 이동
cd apps/ipx-vr

# 2. 프론트엔드 개발 서버 실행
npm run dev

# 3. Laravel 명령어 실행 (Docker 컨테이너 내부)
docker-compose exec php sh -c "cd /var/www/html/apps/ipx-vr && php artisan [command]"
```

### 공통 인프라 관리

```bash
# Docker 컨테이너 관리 (루트 디렉토리)
docker-compose up -d
docker-compose down
```

## 장점

1. **코드 공유**: 공통 라이브러리 및 유틸리티를 쉽게 공유
2. **일관된 환경**: 모든 애플리케이션이 동일한 인프라 사용
3. **버전 관리**: 단일 리포지토리로 버전 관리 단순화
4. **CI/CD**: 통합 빌드 및 배포 파이프라인 구축 용이

## 참고

- [Monorepo 전환 가이드](monorepo-migration.md)
- [프로젝트 현황](project-status.md)

