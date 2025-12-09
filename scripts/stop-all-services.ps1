# IPX-Framework 관련 프로세스 및 서비스 종료 스크립트
# 관리자 권한 PowerShell에서 실행 필요

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IPX-Framework 서비스 종료" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. PHP 프로세스 종료
Write-Host "[1] PHP 프로세스 확인 및 종료..." -ForegroundColor Yellow
$phpProcesses = Get-Process | Where-Object {$_.ProcessName -like "*php*"}
if ($phpProcesses) {
    foreach ($proc in $phpProcesses) {
        Write-Host "  종료 중: $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor Yellow
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  ✓ PHP 프로세스 종료 완료" -ForegroundColor Green
} else {
    Write-Host "  ✓ 실행 중인 PHP 프로세스 없음" -ForegroundColor Green
}

Write-Host ""

# 2. MySQL/MariaDB 프로세스 종료
Write-Host "[2] MySQL/MariaDB 프로세스 확인 및 종료..." -ForegroundColor Yellow
$mysqlProcesses = Get-Process | Where-Object {$_.ProcessName -match "mysql|mariadb"}
if ($mysqlProcesses) {
    foreach ($proc in $mysqlProcesses) {
        Write-Host "  종료 중: $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor Yellow
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  ✓ MySQL/MariaDB 프로세스 종료 완료" -ForegroundColor Green
} else {
    Write-Host "  ✓ 실행 중인 MySQL/MariaDB 프로세스 없음" -ForegroundColor Green
}

Write-Host ""

# 3. MariaDB 서비스 종료
Write-Host "[3] MariaDB 서비스 확인 및 종료..." -ForegroundColor Yellow
$mariaService = Get-Service -Name "IPX-MariaDB" -ErrorAction SilentlyContinue
if ($mariaService) {
    if ($mariaService.Status -eq 'Running') {
        Write-Host "  IPX-MariaDB 서비스 종료 중..." -ForegroundColor Yellow
        Stop-Service -Name "IPX-MariaDB" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        $mariaService = Get-Service -Name "IPX-MariaDB" -ErrorAction SilentlyContinue
        if ($mariaService.Status -eq 'Stopped') {
            Write-Host "  ✓ IPX-MariaDB 서비스 종료 완료" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ IPX-MariaDB 서비스 종료 실패 (관리자 권한 필요)" -ForegroundColor Red
        }
    } else {
        Write-Host "  ✓ IPX-MariaDB 서비스 이미 중지됨" -ForegroundColor Green
    }
} else {
    Write-Host "  ✓ IPX-MariaDB 서비스 없음" -ForegroundColor Green
}

Write-Host ""

# 4. Worker/Queue 프로세스 종료
Write-Host "[4] Worker/Queue 프로세스 확인 및 종료..." -ForegroundColor Yellow
$workerProcesses = Get-Process | Where-Object {
    $_.ProcessName -match "worker|queue|artisan|laravel|horizon"
}
if ($workerProcesses) {
    foreach ($proc in $workerProcesses) {
        Write-Host "  종료 중: $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor Yellow
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  ✓ Worker/Queue 프로세스 종료 완료" -ForegroundColor Green
} else {
    Write-Host "  ✓ 실행 중인 Worker/Queue 프로세스 없음" -ForegroundColor Green
}

Write-Host ""

# 5. Docker 컨테이너 확인
Write-Host "[5] Docker 컨테이너 확인..." -ForegroundColor Yellow
try {
    $dockerContainers = docker ps -a 2>&1
    if ($LASTEXITCODE -eq 0) {
        $runningContainers = docker ps --format "{{.Names}}" 2>&1
        if ($runningContainers -and $runningContainers.Count -gt 0) {
            Write-Host "  실행 중인 Docker 컨테이너:" -ForegroundColor Yellow
            foreach ($container in $runningContainers) {
                if ($container) {
                    Write-Host "    - $container" -ForegroundColor White
                }
            }
            Write-Host ""
            Write-Host "  Docker 컨테이너를 종료하려면:" -ForegroundColor Yellow
            Write-Host "    docker-compose down" -ForegroundColor White
            Write-Host "    또는" -ForegroundColor White
            Write-Host "    docker stop container_name" -ForegroundColor White
        } else {
            Write-Host "  ✓ 실행 중인 Docker 컨테이너 없음" -ForegroundColor Green
        }
    }
} catch {
    Write-Host "  ⚠ Docker 명령 실행 실패 (Docker가 설치되어 있지 않을 수 있음)" -ForegroundColor Yellow
}

Write-Host ""

# 최종 확인
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "종료 완료 확인" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$remainingProcesses = Get-Process | Where-Object {
    $_.ProcessName -match "php|mysql|mariadb|worker|queue|artisan|laravel"
} | Select-Object ProcessName, Id

if ($remainingProcesses) {
    Write-Host "⚠ 다음 프로세스가 여전히 실행 중입니다:" -ForegroundColor Yellow
    $remainingProcesses | Format-Table -AutoSize
    Write-Host "관리자 권한으로 다시 실행하거나 수동으로 종료하세요." -ForegroundColor Yellow
} else {
    Write-Host "All related processes have been stopped." -ForegroundColor Green
}

Write-Host ""

