# 포트 구성 정보

## 현재 포트 구성

### 프론트엔드 + 백엔드 (IPX-Framework)
- **포트**: `8890`
- **URL**: `http://localhost:8890`
- **서비스**: Nginx (Laravel API + Vue.js SPA)
- **구성**:
  - `/` → Vue.js SPA (프론트엔드 UI)
  - `/api/*` → Laravel API (백엔드)
  - `/build/*` → Vite 빌드 파일
- **비고**: 기존 VR 시스템(8888)과 충돌 방지

### 백엔드 API (Laravel)
- **포트**: `8890` (Nginx를 통해 라우팅)
- **API 경로**: `http://localhost:8890/api/*`
- **역할**: RESTful API 제공, 비즈니스 로직 처리, 비동기 작업 관리

### 데이터베이스
- **외부 접속**: `127.0.0.1:3307`
- **내부 접속**: `mariadb:3306` (Docker 네트워크)

### Redis
- **포트**: `6379`
- **접속**: `127.0.0.1:6379` 또는 `redis:6379` (Docker 네트워크)

### Vite 개발 서버 (개발 모드)
- **포트**: `5173`
- **HMR**: `http://localhost:5173`
- **비고**: Laravel 웹 서버(8890)와 분리하여 포트 충돌 방지

## 포트 충돌 방지

### 기존 시스템과의 충돌
- **VR 시스템**: `http://localhost:8888` (기존 시스템)
- **IPX-Framework**: `http://localhost:8890` (신규 시스템)

### 변경 이력
- 2024-12-08: 프론트엔드 포트를 80 → 8890으로 변경
  - 이유: 기존 VR 시스템(8888)과 충돌 방지
  - 영향: Nginx 포트 매핑, APP_URL 설정
- 2024-12-09: Vite 개발 서버 포트를 8890 → 5173으로 분리
  - 이유: Laravel 웹 서버(8890)와 Vite 개발 서버 포트 충돌 방지
  - 영향: vite.config.js의 server.port, hmr.port 설정

## 설정 파일

### docker-compose.yml
```yaml
nginx:
  ports:
    - "8890:80"  # 호스트 8890 -> 컨테이너 80
```

### apps/ipx-vr/vite.config.js
```javascript
server: {
  host: '0.0.0.0',
  port: 5173,  // Vite 개발 서버 포트 (Laravel 8890과 분리)
  hmr: {
    host: 'localhost',
    port: 5173
  },
  fs: {
    allow: [
      '..',
      '../../node_modules',
      path.resolve(__dirname, '../..')
    ]
  }
}
```

### .env
```env
APP_URL=http://localhost:8890
```

## 접속 확인

### 브라우저
```
http://localhost:8890
```

### API 테스트
```bash
curl http://localhost:8890/api/health
```

## 문제 해결

### 포트가 이미 사용 중일 때
```bash
# 포트 사용 확인
netstat -ano | findstr :8890

# 다른 포트로 변경 시
# docker-compose.yml의 nginx 포트 변경
# vite.config.js의 server.port 변경
# .env의 APP_URL 변경
```

### Nginx 재시작
```bash
docker-compose restart nginx
```

