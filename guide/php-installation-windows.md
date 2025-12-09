# PHP 8.4 Windows 설치 가이드

## 개요
IPX-Framework 개발을 위한 PHP 8.4 및 필수 확장 프로그램 설치 가이드입니다.

## 방법 1: Chocolatey를 사용한 설치 (권장)

### 1.1 Chocolatey 설치 확인
```powershell
choco --version
```

Chocolatey가 설치되어 있지 않다면:
```powershell
# 관리자 권한 PowerShell에서 실행
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### 1.2 PHP 8.4 설치
```powershell
# 관리자 권한 PowerShell에서 실행
choco install php --version=8.4.0 -y
```

### 1.3 필수 PHP 확장 설치
```powershell
# PDO 및 MySQL 확장
choco install php-extension-pdo_mysql -y

# Redis 확장 (PECL 필요)
# 또는 수동 설치 필요
```

### 1.4 Composer 설치
```powershell
choco install composer -y
```

---

## 방법 2: 수동 설치

### 2.1 PHP 8.4 다운로드 및 설치

1. **PHP 다운로드**
   - https://windows.php.net/download/ 에서 PHP 8.4 Thread Safe 버전 다운로드
   - ZIP 파일을 `C:\php` 디렉토리에 압축 해제

2. **환경 변수 설정**
   ```powershell
   # PowerShell (관리자 권한)
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\php", [EnvironmentVariableTarget]::Machine)
   ```

3. **PHP 설정 파일 복사**
   ```powershell
   cd C:\php
   copy php.ini-development php.ini
   ```

### 2.2 필수 PHP 확장 활성화

`php.ini` 파일을 열어 다음 확장 프로그램의 주석을 제거:

```ini
; 필수 확장 프로그램
extension=pdo
extension=pdo_mysql
extension=mysqli
extension=gd
extension=zip
extension=mbstring
extension=exif
extension=pcntl
extension=bcmath
extension=opcache
extension=intl

; Redis 확장 (PECL로 설치 필요)
; extension=redis
```

### 2.3 PHP 설정 최적화

`php.ini`에서 다음 설정을 확인/수정:

```ini
; 메모리 및 업로드 제한
memory_limit = 512M
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300

; OPcache 및 JIT 설정
opcache.enable=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=20000
opcache.validate_timestamps=0
opcache.jit_buffer_size=256M
opcache.jit=tracing

; 타임존 설정
date.timezone = Asia/Seoul
```

### 2.4 Redis 확장 설치 (PECL)

Windows에서 Redis 확장을 설치하려면:

1. **PECL 다운로드**
   - https://pecl.php.net/package/redis 에서 Windows DLL 다운로드
   - 또는 pre-compiled DLL 사용: https://windows.php.net/downloads/pecl/releases/redis/

2. **DLL 파일 복사**
   - 다운로드한 `php_redis.dll`을 `C:\php\ext` 디렉토리에 복사

3. **php.ini에 추가**
   ```ini
   extension=redis
   ```

### 2.5 Composer 설치

```powershell
# PowerShell에서 실행
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# 전역 설치 (선택사항)
move composer.phar C:\php\composer.phar
```

또는 Composer Windows Installer 사용:
- https://getcomposer.org/Composer-Setup.exe 다운로드 및 실행

---

## 설치 확인

### PHP 버전 확인
```powershell
php -v
```
예상 출력: `PHP 8.4.x (cli) ...`

### 필수 확장 확인
```powershell
php -m
```

다음 확장이 표시되어야 합니다:
- pdo
- pdo_mysql
- mysqli
- gd
- zip
- mbstring
- bcmath
- opcache
- intl
- redis (선택사항, Queue 사용 시 필수)

### OPcache 및 JIT 확인
```powershell
php -i | findstr opcache
php -i | findstr jit
```

### Composer 확인
```powershell
composer --version
```

---

## 문제 해결

### PHP가 인식되지 않을 때
1. 환경 변수 PATH 확인
2. PowerShell 재시작
3. 시스템 재부팅 (필요 시)

### 확장 프로그램이 로드되지 않을 때
1. `php.ini`에서 `extension_dir` 경로 확인
2. DLL 파일이 올바른 위치에 있는지 확인
3. PHP 버전과 확장 버전이 일치하는지 확인

### Redis 확장 설치 문제
- Windows에서는 Redis 확장 설치가 복잡할 수 있음
- Docker 환경 사용을 권장 (docker-compose.yml 참조)

---

## Docker 환경 사용 (대안)

로컬 PHP 설치가 복잡한 경우, Docker 환경을 사용할 수 있습니다:

```powershell
# Docker 환경 실행
docker-compose up -d

# PHP 컨테이너에서 명령 실행
docker-compose exec php php -v
docker-compose exec php composer --version
```

Docker 환경에서는 모든 필수 확장이 이미 설치되어 있습니다.

---

## 다음 단계

설치가 완료되면:

1. **프로젝트 의존성 설치**
   ```powershell
   composer install
   npm install
   ```

2. **환경 변수 설정**
   ```powershell
   copy .env.example .env
   php artisan key:generate
   ```

3. **개발 시작**
   - `/guide/00-setup.md` 참조

