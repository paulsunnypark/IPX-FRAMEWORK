# Windows Docker 볼륨 격리 해결 방법

## 문제 상황

Windows에서 Docker 볼륨 마운트를 사용할 때 `chmod(): Operation not permitted` 오류가 발생합니다. 특히 `bootstrap/cache` 폴더에서 패키지 매니페스트 생성 과정에서 오류가 발생합니다.

## 해결 방법: 문제 폴더만 Docker Named Volume으로 격리

소스 코드는 Windows에 두되, 권한 오류가 발생하는 `storage`와 `bootstrap/cache` 폴더만 Docker가 관리하는 Linux 공간으로 연결합니다.

### 1. `docker-compose.yml` 설정

```yaml
services:
  php:
    volumes:
      - ./:/var/www/html  # 전체 소스는 Windows 폴더 사용 (수정 가능)
      # 권한 에러가 나는 폴더들만 도커 볼륨(Linux FS)으로 덮어쓰기
      - ipx_storage:/var/www/html/storage
      - ipx_bootstrap_cache:/var/www/html/bootstrap/cache

volumes:
  mariadb_data:
  redis_data:
  ipx_storage:         # Laravel storage 폴더 (권한 문제 해결)
  ipx_bootstrap_cache: # Laravel bootstrap/cache 폴더 (권한 문제 해결)
```

**중요**: 볼륨 마운트 순서가 중요합니다. 전체 경로(`./:/var/www/html`)를 먼저 마운트하고, 그 다음에 특정 폴더를 덮어쓰는 방식으로 설정해야 합니다.

### 2. 컨테이너 강제 재생성

설정 파일만 바꾸고 기존 컨테이너를 재사용하면 볼륨 마운트가 바뀌지 않을 수 있습니다. **반드시 아래 명령어로 컨테이너를 완전히 삭제 후 다시 띄워야 합니다.**

```bash
# 1. 기존 컨테이너 및 네트워크 완전 삭제
docker-compose down

# 2. 변경된 설정을 적용하여 강제 재생성 및 실행
docker-compose up -d --force-recreate --build
```

### 3. 볼륨 권한 초기화

새로운 볼륨이 생성되면 내부가 비어 있거나 권한이 없을 수 있습니다. PHP 컨테이너 내부에서 초기화를 진행합니다.

```bash
# 1. PHP 컨테이너 접속
docker-compose exec php bash

# 2. 캐시 디렉토리 생성 및 권한 부여 (컨테이너 내부)
mkdir -p bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# 3. 패키지 캐시 재생성 (이제 에러가 안 나야 정상입니다)
php artisan package:discover
```

### 4. 확인 방법

위 3단계를 수행한 후, 브라우저에서 `http://localhost:8890`을 다시 새로고침 해보세요.

- ✅ `chmod` 오류가 사라지고 Laravel 초기 화면이 정상적으로 표시됩니다.
- ✅ `php artisan package:discover` 명령이 오류 없이 실행됩니다.
- ✅ `php artisan optimize:clear` 명령이 오류 없이 실행됩니다.

## 추가 참고사항

### Docker Desktop 설정 확인

만약 이 과정을 거쳤는데도 똑같은 오류가 난다면, **Docker Desktop 설정**에서 `Use the WSL 2 based engine`이 체크되어 있는지 확인해 주십시오. (체크되어 있어야 볼륨 성능과 호환성이 가장 좋습니다.)

### 볼륨 마운트 확인

볼륨이 제대로 마운트되었는지 확인하려면:

```bash
# 볼륨 목록 확인
docker volume ls | grep ipx

# 컨테이너 내부에서 마운트 확인
docker-compose exec php df -h | grep storage
docker-compose exec php df -h | grep bootstrap
```

## 장점

1. **소스 코드 수정 가능**: Windows 폴더에서 직접 파일 수정 가능
2. **권한 문제 해결**: `storage`와 `bootstrap/cache`는 Linux 파일 시스템에서 작동
3. **성능 향상**: Named Volume은 Windows 볼륨 마운트보다 성능이 좋습니다
4. **chmod() 정상 작동**: Linux 파일 시스템에서는 chmod()가 정상적으로 작동합니다

## 주의사항

- `storage`와 `bootstrap/cache` 폴더의 내용은 Docker 볼륨에 저장되므로, Windows 폴더에서 직접 확인할 수 없습니다.
- 볼륨을 삭제하면 저장된 데이터가 모두 삭제됩니다. (`docker volume rm` 명령 사용 시 주의)

