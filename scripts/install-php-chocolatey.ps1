# IPX-Framework PHP 설치 스크립트 (Chocolatey 사용)
# 관리자 권한 PowerShell에서 실행 필요

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IPX-Framework PHP 8.4 설치" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Chocolatey 확인
Write-Host "[1] Chocolatey 확인..." -ForegroundColor Yellow
try {
    $chocoVersion = choco --version 2>&1
    if ($chocoVersion) {
        Write-Host "  Chocolatey $chocoVersion 설치됨" -ForegroundColor Green
    }
} catch {
    Write-Host "  Chocolatey가 설치되어 있지 않습니다." -ForegroundColor Red
    Write-Host "  Chocolatey 설치 중..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Write-Host ""

# PHP 8.4 설치
Write-Host "[2] PHP 8.4 설치 중..." -ForegroundColor Yellow
choco install php --version=8.4.0 -y

Write-Host ""

# PHP 확장 설치
Write-Host "[3] PHP 확장 설치 중..." -ForegroundColor Yellow
choco install php-extension-pdo_mysql -y

Write-Host ""

# Composer 설치
Write-Host "[4] Composer 설치 중..." -ForegroundColor Yellow
choco install composer -y

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "설치 완료!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "다음 명령으로 확인하세요:" -ForegroundColor Yellow
Write-Host "  php -v" -ForegroundColor White
Write-Host "  composer --version" -ForegroundColor White
Write-Host ""
Write-Host "필수 확장 확인:" -ForegroundColor Yellow
Write-Host "  php -m" -ForegroundColor White
Write-Host ""
Write-Host "Redis 확장은 수동 설치가 필요할 수 있습니다." -ForegroundColor Yellow
Write-Host "자세한 내용: /guide/php-installation-windows.md" -ForegroundColor Cyan

