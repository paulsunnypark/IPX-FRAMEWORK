# IPX-Framework PHP PATH 설정 스크립트
# 관리자 권한 PowerShell에서 실행 필요

$phpPath = "D:\IPX-Web\WAS_v3.0\php-8.4.x"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PHP PATH 설정" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# PHP 경로 확인
if (Test-Path "$phpPath\php.exe") {
    Write-Host "  PHP 경로 확인: $phpPath" -ForegroundColor Green
} else {
    Write-Host "  PHP 경로를 찾을 수 없습니다: $phpPath" -ForegroundColor Red
    exit 1
}

# 현재 PATH 확인
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$pathArray = $currentPath -split ';'

if ($pathArray -contains $phpPath) {
    Write-Host "  PHP 경로가 이미 PATH에 등록되어 있습니다." -ForegroundColor Yellow
} else {
    Write-Host "  PHP 경로를 PATH에 추가 중..." -ForegroundColor Yellow
    
    # 시스템 PATH에 추가
    $newPath = $currentPath + ";$phpPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    
    # 현재 세션에도 추가
    $env:Path += ";$phpPath"
    
    Write-Host "  PHP 경로가 PATH에 추가되었습니다." -ForegroundColor Green
    Write-Host "  PowerShell을 재시작하면 적용됩니다." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "설정 완료!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "다음 명령으로 확인하세요:" -ForegroundColor Yellow
Write-Host "  php -v" -ForegroundColor White
Write-Host ""

