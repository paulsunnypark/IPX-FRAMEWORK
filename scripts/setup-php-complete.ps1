# IPX-Framework PHP 완전 설정 스크립트
# 관리자 권한 PowerShell에서 실행 필요

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IPX-Framework PHP 완전 설정" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. PATH 설정
Write-Host "[1/3] PHP PATH 설정..." -ForegroundColor Yellow
& "$PSScriptRoot\setup-php-path.ps1"

Write-Host ""

# 2. 확장 프로그램 설정
Write-Host "[2/3] PHP 확장 프로그램 설정..." -ForegroundColor Yellow
& "$PSScriptRoot\configure-php-extensions.ps1"

Write-Host ""

# 3. 확인
Write-Host "[3/3] 설치 확인..." -ForegroundColor Yellow
$phpPath = "D:\IPX-Web\WAS_v3.0\php-8.4.x"

if (Test-Path "$phpPath\php.exe") {
    Write-Host ""
    Write-Host "PHP 버전:" -ForegroundColor Cyan
    & "$phpPath\php.exe" -v
    
    Write-Host ""
    Write-Host "설치된 확장 프로그램:" -ForegroundColor Cyan
    $extensions = & "$phpPath\php.exe" -m
    $required = @("pdo", "pdo_mysql", "mysqli", "gd", "zip", "mbstring", "bcmath", "opcache", "intl")
    
    foreach ($ext in $required) {
        if ($extensions -match "^$ext$") {
            Write-Host "  ✓ $ext" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $ext" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "OPcache 상태:" -ForegroundColor Cyan
    $opcacheInfo = & "$phpPath\php.exe" -i 2>&1 | Select-String "opcache.enable"
    Write-Host "  $opcacheInfo" -ForegroundColor White
} else {
    Write-Host "  ✗ PHP를 찾을 수 없습니다." -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "설정 완료!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "다음 단계:" -ForegroundColor Yellow
Write-Host "  1. PowerShell을 재시작하여 PATH 변경사항 적용" -ForegroundColor White
Write-Host "  2. Composer 설치 확인 또는 설치" -ForegroundColor White
Write-Host "  3. 프로젝트 의존성 설치: composer install" -ForegroundColor White
Write-Host ""

