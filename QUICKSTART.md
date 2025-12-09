# IPX-Framework 빠른 시작 가이드

## 현재 시스템 상태

✅ **Laravel 11** 설치 완료
✅ **Docker 환경** 구성 완료 (Nginx, PHP-FPM, MariaDB, Redis)
✅ **Multi-Database** 설정 완료 (ipx_master, ipx_vr)
⚠️ **의존성 설치**: composer install 재시도 필요 (타임아웃 발생)

## 개발 환경 설정

### Docker 환경 사용 (권장) ⭐

Docker를 사용하면 모든 환경이 자동으로 설정됩니다.

```bash
# Docker 컨테이너 실행
docker-compose up -d

# Laravel 의존성 설치
docker-compose exec php composer install

# 애플리케이션 키 생성
docker-compose exec php php artisan key:generate

# 데이터베이스 마이그레이션
docker-compose exec php php artisan migrate --database=mysql_master
docker-compose exec php php artisan migrate --database=mysql_vr
```

**장점**:
- 모든 필수 확장이 자동 설치됨
- 환경 설정 불필요
- 팀원과 동일한 환경 보장
- Multi-Database 자동 구성

### 로컬 PHP 사용 (선택사항)

로컬 PHP를 사용하려면:

#### 2-1. Chocolatey 사용 (가장 쉬움)

```powershell
# 관리자 권한 PowerShell에서 실행
.\scripts\install-php-chocolatey.ps1
```

또는 수동으로:

```powershell
# Chocolatey 설치 (없는 경우)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# PHP 8.4 설치
choco install php --version=8.4.0 -y

# Composer 설치
choco install composer -y
```

#### 2-2. 수동 설치

자세한 내용: [`/guide/php-installation-windows.md`](guide/php-installation-windows.md)

---

## 설치 확인

설치 후 다음 명령으로 확인:

```powershell
# PHP 버전 확인
php -v

# 필수 확장 확인
php -m

# Composer 확인
composer --version
```

또는 확인 스크립트 실행:

```powershell
.\scripts\check-php-requirements.ps1
```

---

## 필수 요구사항

### PHP 8.4+ 필수 확장
- ✅ pdo
- ✅ pdo_mysql
- ✅ mysqli
- ✅ gd
- ✅ zip
- ✅ mbstring
- ✅ bcmath
- ✅ opcache
- ✅ intl

### 선택 확장 (권장)
- ⚠️ redis (Queue 사용 시 필수)

### 기타 도구
- ✅ Composer 2.6+

---

## 다음 단계

### 1. Laravel 의존성 설치 완료

```bash
docker-compose exec php composer install
```

타임아웃 발생 시 재시도하거나 타임아웃 시간 증가:
```bash
docker-compose exec php composer install --no-interaction --prefer-dist
```

### 2. 애플리케이션 키 생성

```bash
docker-compose exec php php artisan key:generate
```

### 3. 데이터베이스 마이그레이션

```bash
# Master DB 마이그레이션
docker-compose exec php php artisan migrate --database=mysql_master

# VR DB 마이그레이션
docker-compose exec php php artisan migrate --database=mysql_vr
```

### 4. 개발 시작

- [`/guide/00-setup.md`](guide/00-setup.md) 참조
- [`DATABASE-SETUP.md`](DATABASE-SETUP.md) - 데이터베이스 설정 가이드

---

## 문제 해결

### PHP가 인식되지 않을 때
- 환경 변수 PATH에 PHP 경로 추가
- PowerShell 재시작
- 시스템 재부팅

### 확장이 로드되지 않을 때
- `php.ini`에서 `extension_dir` 확인
- 확장 DLL 파일 경로 확인

### 더 많은 도움
- [`/guide/php-installation-windows.md`](guide/php-installation-windows.md)
- [`/guide/00-setup.md`](guide/00-setup.md)

