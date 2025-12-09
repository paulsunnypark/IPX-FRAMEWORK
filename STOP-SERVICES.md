# IPX-Framework 서비스 종료 가이드

## 현재 상태

다음 프로세스가 실행 중입니다:
- **mysqld** (PID: 7260) - 관리자 권한 필요
- **MoUsoCoreWorker** (PID: 9560) - 관리자 권한 필요
- **IPX-MariaDB** 서비스 - 관리자 권한 필요

## 종료 방법

### 방법 1: 관리자 권한 PowerShell에서 스크립트 실행 (권장)

1. **PowerShell을 관리자 권한으로 실행**
   - 시작 메뉴에서 "PowerShell" 검색
   - "Windows PowerShell" 우클릭 → "관리자 권한으로 실행"

2. **프로젝트 디렉토리로 이동**
   ```powershell
   cd E:\IPX-Framework
   ```

3. **종료 스크립트 실행**
   ```powershell
   .\scripts\stop-services-simple.ps1
   ```

### 방법 2: 수동 종료

#### MariaDB 서비스 종료
```powershell
# 관리자 권한 PowerShell에서
Stop-Service -Name "IPX-MariaDB" -Force
```

#### mysqld 프로세스 종료
```powershell
# 관리자 권한 PowerShell에서
taskkill /F /PID 7260
```

또는
```powershell
Stop-Process -Id 7260 -Force
```

#### MoUsoCoreWorker 프로세스 종료
```powershell
# 관리자 권한 PowerShell에서
taskkill /F /PID 9560
```

### 방법 3: 작업 관리자 사용

1. **작업 관리자 열기** (Ctrl + Shift + Esc)
2. **프로세스 탭**에서 다음 프로세스 찾기:
   - mysqld.exe
   - MoUsoCoreWorker.exe
3. 각 프로세스 우클릭 → **작업 끝내기**

### 방법 4: 서비스 관리자 사용

1. **서비스 관리자 열기** (Win + R → `services.msc`)
2. **IPX-MariaDB** 서비스 찾기
3. 우클릭 → **중지**

## 확인

종료 후 다음 명령으로 확인:

```powershell
# 실행 중인 프로세스 확인
Get-Process | Where-Object {$_.ProcessName -match "php|mysql|mariadb|worker|queue|artisan|laravel"}

# 서비스 상태 확인
Get-Service -Name "IPX-MariaDB"
```

## Docker 컨테이너 종료 (해당되는 경우)

```powershell
# 실행 중인 컨테이너 확인
docker ps

# 모든 컨테이너 종료
docker-compose down

# 특정 컨테이너 종료
docker stop <container_name>
```

## 문제 해결

### "액세스가 거부되었습니다" 오류
- PowerShell을 **관리자 권한**으로 실행해야 합니다.

### 프로세스가 계속 실행되는 경우
- 작업 관리자에서 **강제 종료** 시도
- 시스템 재시작 (최후의 수단)

### 서비스가 자동으로 재시작되는 경우
- 서비스 관리자에서 **시작 유형**을 "수동" 또는 "사용 안 함"으로 변경

