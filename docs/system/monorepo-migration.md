# Monorepo 구조 전환 완료

**작업 일자**: 2024-12-09

## 개요

IPX-Framework를 Monorepo 구조로 전환하여 확장 가능한 아키텍처를 구축했습니다.

## 변경 사항

### 파일 구조 변경

**이전 구조**:
```
/ipx-framework
├── app/
├── bootstrap/
├── config/
├── public/
├── resources/
└── ...
```

**변경 후 구조**:
```
/ipx-framework
├── apps/
│   └── ipx-vr/            # VR 애플리케이션
│       ├── app/
│       ├── bootstrap/
│       ├── config/
│       ├── public/
│       ├── resources/
│       └── ...
├── docker/
├── tasks/
└── docs/
```

### 이동된 파일 목록

다음 18개 항목이 `apps/ipx-vr/`로 이동되었습니다:

- `app/`
- `bootstrap/`
- `config/`
- `database/`
- `public/`
- `resources/`
- `routes/`
- `storage/`
- `vendor/`
- `.env`
- `.env.example`
- `artisan`
- `composer.json`
- `composer.lock`
- `package.json`
- `package-lock.json`
- `vite.config.js`
- `phpunit.xml`

### 설정 파일 변경

#### 1. `docker-compose.yml`

- **working_dir**: `/var/www/html/apps/ipx-vr`
- **Named Volume 경로**:
  - `ipx_vr_storage:/var/www/html/apps/ipx-vr/storage`
  - `ipx_vr_bootstrap_cache:/var/www/html/apps/ipx-vr/bootstrap/cache`
- **데모 데이터 마운트**: `D:\IPX-Storage\FILES\VR_REC:/var/www/recordings_root`
- **Nginx 볼륨**: `./:/var/www/html:ro` (전체 디렉토리 마운트)

#### 2. `docker/nginx/conf.d/default.conf`

- **root**: `/var/www/html/apps/ipx-vr/public`
- **storage alias**: `/var/www/html/apps/ipx-vr/storage/app/public`

#### 3. `.gitignore`

Monorepo 구조에 맞게 경로 패턴 변경:
```gitignore
apps/*/vendor/
apps/*/.env
apps/*/storage/*.key
apps/*/public/hot
apps/*/public/build
apps/*/node_modules/
```

## 장점

1. **확장성**: 향후 다른 애플리케이션(`ipx-ivr`, `ipx-nms` 등) 추가 용이
2. **명확한 구조**: 각 애플리케이션이 독립적인 디렉토리에 위치
3. **관리 용이**: 인프라 설정(`docker/`)과 문서(`docs/`)가 루트에 위치

## 완료 확인

- ✅ 웹 접속 확인 완료: `http://localhost:8890` 정상 작동
- ✅ Nginx 경로 설정 완료
- ✅ PHP 컨테이너 working_dir 설정 완료

## 다음 단계

1. **프론트엔드 개발 서버 재실행**:
   ```bash
   cd apps/ipx-vr
   npm run dev
   ```

2. **데모 데이터 통합 Phase 1 시작**

## 참고

- [프로젝트 현황](project-status.md)
- [Context Contraction](../../tasks/context-contraction.md)

