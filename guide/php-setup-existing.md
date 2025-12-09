# 기존 PHP 8.4 설정 가이드

## 현재 상태

✅ **PHP 8.4.8** 설치 확인: `D:\IPX-Web\WAS_v3.0\php-8.4.x`

### 설치된 확장 프로그램
- ✅ pdo
- ✅ pdo_mysql
- ✅ mysqli
- ✅ gd
- ✅ zip
- ✅ mbstring
- ✅ bcmath
- ⚠️ opcache (비활성화 상태, 활성화 필요)
- ⚠️ intl (비활성화 상태, 활성화 필요)
- ❌ redis (별도 설치 필요, Queue 사용 시 권장)

---

## 설정 단계

### 1. PHP PATH 설정 (필수)

PowerShell을 **관리자 권한**으로 실행하고:

```powershell
# 프로젝트 디렉토리로 이동
cd E:\IPX-Framework

# PATH 설정 스크립트 실행
.\scripts\setup-php-path.ps1
```

또는 수동으로:

```powershell
# 시스템 환경 변수에 PHP 경로 추가
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";D:\IPX-Web\WAS_v3.0\php-8.4.x", [EnvironmentVariableTarget]::Machine)

# 현재 세션에도 추가
$env:Path += ";D:\IPX-Web\WAS_v3.0\php-8.4.x"
```

**PowerShell을 재시작**한 후 확인:

```powershell
php -v
```

---

### 2. PHP 확장 프로그램 활성화 (필수)

PowerShell을 **관리자 권한**으로 실행하고:

```powershell
# 확장 프로그램 설정 스크립트 실행
.\scripts\configure-php-extensions.ps1
```

이 스크립트는 다음을 수행합니다:
- ✅ OPcache 활성화 및 JIT 설정
- ✅ intl 확장 활성화
- ✅ 메모리 제한: 512M
- ✅ 업로드 제한: 100M
- ✅ 실행 시간 제한: 300초
- ✅ 타임존: Asia/Seoul

**php.ini 백업**이 자동으로 생성됩니다: `php.ini.ipx-backup`

---

### 3. 한 번에 설정하기 (권장)

PowerShell을 **관리자 권한**으로 실행하고:

```powershell
# 완전 설정 스크립트 실행
.\scripts\setup-php-complete.ps1
```

이 스크립트는 위의 모든 설정을 자동으로 수행합니다.

---

## 설정 확인

### PHP 버전 확인
```powershell
php -v
```
예상 출력: `PHP 8.4.8 (cli) ...`

### 확장 프로그램 확인
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
- **opcache** (활성화 후)
- **intl** (활성화 후)

### OPcache 확인
```powershell
php -i | findstr opcache
```

### 확인 스크립트 실행
```powershell
.\scripts\check-php-requirements.ps1
```

---

## Composer 설치

### Composer 설치 확인
```powershell
composer --version
```

### Composer가 없을 경우

#### 방법 1: Composer Windows Installer (권장)
1. https://getcomposer.org/Composer-Setup.exe 다운로드
2. 설치 시 PHP 경로 지정: `D:\IPX-Web\WAS_v3.0\php-8.4.x\php.exe`

#### 방법 2: 수동 설치
```powershell
# Composer 다운로드
cd D:\IPX-Web\WAS_v3.0\php-8.4.x
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# 전역 설치 (선택사항)
# composer.phar를 PATH에 등록된 디렉토리로 이동
```

---

## Redis 확장 설치 (선택사항)

Queue 기능을 사용하려면 Redis 확장이 필요합니다.

### Windows에서 Redis 확장 설치

1. **PECL Redis 다운로드**
   - https://windows.php.net/downloads/pecl/releases/redis/
   - PHP 8.4 Thread Safe (TS) x64 버전 다운로드

2. **DLL 파일 복사**
   - 다운로드한 `php_redis.dll`을 `D:\IPX-Web\WAS_v3.0\php-8.4.x\ext\` 디렉토리에 복사

3. **php.ini에 추가**
   ```ini
   extension=redis
   ```

4. **확인**
   ```powershell
   php -m | findstr redis
   ```

**참고**: Windows에서 Redis 확장 설치가 복잡할 수 있습니다. Docker 환경 사용을 권장합니다.

---

## 다음 단계

설정이 완료되면:

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
   - [`/guide/00-setup.md`](00-setup.md) 참조

---

## 문제 해결

### PHP가 인식되지 않을 때
- PowerShell 재시작
- 시스템 재부팅
- 환경 변수 PATH 확인

### 확장이 로드되지 않을 때
- `php.ini`에서 `extension_dir` 확인
- DLL 파일이 올바른 위치에 있는지 확인
- PHP 버전과 확장 버전 일치 확인

### OPcache가 작동하지 않을 때
- `php.ini`에서 `zend_extension=opcache` 주석 제거 확인
- OPcache 설정 섹션 확인

---

## Docker 환경 사용 (대안)

로컬 PHP 설정이 복잡하거나 문제가 있을 경우, Docker 환경을 사용할 수 있습니다:

```powershell
# Docker 환경 실행
docker-compose up -d

# PHP 컨테이너에서 명령 실행
docker-compose exec php php -v
docker-compose exec php composer --version
```

Docker 환경에서는 모든 필수 확장이 이미 설치되어 있습니다.

