# IPX-Framework 서비스 종료 스크립트 (간단 버전)
# 관리자 권한 PowerShell에서 실행 필요

Write-Host "Stopping IPX-Framework services..." -ForegroundColor Cyan
Write-Host ""

# MySQL/MariaDB 프로세스 종료
Write-Host "[1] Stopping MySQL/MariaDB processes..." -ForegroundColor Yellow
$mysqlProcs = Get-Process | Where-Object {$_.ProcessName -match "mysql|mariadb"}
if ($mysqlProcs) {
    foreach ($p in $mysqlProcs) {
        Write-Host "  Stopping: $($p.ProcessName) (PID: $($p.Id))" -ForegroundColor White
        taskkill /F /PID $p.Id 2>&1 | Out-Null
    }
    Write-Host "  Done" -ForegroundColor Green
} else {
    Write-Host "  No MySQL/MariaDB processes found" -ForegroundColor Green
}

# MariaDB 서비스 종료
Write-Host "[2] Stopping IPX-MariaDB service..." -ForegroundColor Yellow
$service = Get-Service -Name "IPX-MariaDB" -ErrorAction SilentlyContinue
if ($service -and $service.Status -eq 'Running') {
    Stop-Service -Name "IPX-MariaDB" -Force -ErrorAction SilentlyContinue
    Write-Host "  Done" -ForegroundColor Green
} else {
    Write-Host "  Service not running or not found" -ForegroundColor Green
}

# PHP 프로세스 종료
Write-Host "[3] Stopping PHP processes..." -ForegroundColor Yellow
$phpProcs = Get-Process | Where-Object {$_.ProcessName -like "*php*"}
if ($phpProcs) {
    foreach ($p in $phpProcs) {
        Write-Host "  Stopping: $($p.ProcessName) (PID: $($p.Id))" -ForegroundColor White
        taskkill /F /PID $p.Id 2>&1 | Out-Null
    }
    Write-Host "  Done" -ForegroundColor Green
} else {
    Write-Host "  No PHP processes found" -ForegroundColor Green
}

# Worker/Queue 프로세스 종료
Write-Host "[4] Stopping Worker/Queue processes..." -ForegroundColor Yellow
$workerProcs = Get-Process | Where-Object {$_.ProcessName -match "worker|queue|artisan|laravel|horizon"}
if ($workerProcs) {
    foreach ($p in $workerProcs) {
        Write-Host "  Stopping: $($p.ProcessName) (PID: $($p.Id))" -ForegroundColor White
        taskkill /F /PID $p.Id 2>&1 | Out-Null
    }
    Write-Host "  Done" -ForegroundColor Green
} else {
    Write-Host "  No Worker/Queue processes found" -ForegroundColor Green
}

Write-Host ""
Write-Host "Verification..." -ForegroundColor Cyan
$remaining = Get-Process | Where-Object {$_.ProcessName -match "php|mysql|mariadb|worker|queue|artisan|laravel"}
if ($remaining) {
    Write-Host "  Warning: Some processes are still running:" -ForegroundColor Yellow
    $remaining | Format-Table ProcessName, Id -AutoSize
    Write-Host "  Run as Administrator or stop manually" -ForegroundColor Yellow
} else {
    Write-Host "  All processes stopped successfully" -ForegroundColor Green
}

Write-Host ""

