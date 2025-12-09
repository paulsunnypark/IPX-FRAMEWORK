# IPX-Framework PHP 요구사항 확인 스크립트

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IPX-Framework PHP 요구사항 확인" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# PHP 버전 확인
Write-Host "[1] PHP 버전 확인..." -ForegroundColor Yellow
try {
    $phpVersion = php -v 2>&1 | Select-String -Pattern "PHP (\d+\.\d+\.\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($phpVersion) {
        $versionParts = $phpVersion -split '\.'
        $major = [int]$versionParts[0]
        $minor = [int]$versionParts[1]
        
        if ($major -eq 8 -and $minor -ge 4) {
            Write-Host "  ✓ PHP $phpVersion 설치됨 (요구사항: 8.4+)" -ForegroundColor Green
        } else {
            Write-Host "  ✗ PHP $phpVersion 설치됨 (요구사항: 8.4+)" -ForegroundColor Red
            Write-Host "    PHP 8.4 이상이 필요합니다." -ForegroundColor Red
        }
    } else {
        Write-Host "  ✗ PHP가 설치되어 있지 않습니다." -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ PHP가 설치되어 있지 않거나 PATH에 등록되지 않았습니다." -ForegroundColor Red
}

Write-Host ""

# 필수 확장 확인
Write-Host "[2] 필수 PHP 확장 확인..." -ForegroundColor Yellow
$requiredExtensions = @(
    "pdo",
    "pdo_mysql",
    "mysqli",
    "gd",
    "zip",
    "mbstring",
    "bcmath",
    "opcache",
    "intl"
)

$optionalExtensions = @(
    "redis"
)

$missingRequired = @()
$missingOptional = @()

try {
    $installedExtensions = php -m 2>&1
    
    foreach ($ext in $requiredExtensions) {
        if ($installedExtensions -match "^$ext$") {
            Write-Host "  ✓ $ext" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $ext (필수)" -ForegroundColor Red
            $missingRequired += $ext
        }
    }
    
    foreach ($ext in $optionalExtensions) {
        if ($installedExtensions -match "^$ext$") {
            Write-Host "  ✓ $ext (선택)" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ $ext (선택, Queue 사용 시 권장)" -ForegroundColor Yellow
            $missingOptional += $ext
        }
    }
} catch {
    Write-Host "  ✗ PHP 확장 목록을 확인할 수 없습니다." -ForegroundColor Red
}

Write-Host ""

# OPcache 및 JIT 확인
Write-Host "[3] OPcache 및 JIT 설정 확인..." -ForegroundColor Yellow
try {
    $phpInfo = php -i 2>&1
    
    if ($phpInfo -match "opcache\.enable.*=>.*1") {
        Write-Host "  ✓ OPcache 활성화됨" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ OPcache가 비활성화되어 있습니다." -ForegroundColor Yellow
    }
    
    if ($phpInfo -match "opcache\.jit.*=>.*tracing") {
        Write-Host "  ✓ JIT (tracing) 활성화됨" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ JIT가 활성화되지 않았습니다." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠ PHP 설정을 확인할 수 없습니다." -ForegroundColor Yellow
}

Write-Host ""

# Composer 확인
Write-Host "[4] Composer 확인..." -ForegroundColor Yellow
try {
    $composerVersion = composer --version 2>&1 | Select-String -Pattern "Composer version (\S+)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($composerVersion) {
        Write-Host "  ✓ Composer $composerVersion 설치됨" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Composer가 설치되어 있지 않습니다." -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ Composer가 설치되어 있지 않거나 PATH에 등록되지 않았습니다." -ForegroundColor Red
}

Write-Host ""

# 요약
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "요약" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($missingRequired.Count -eq 0) {
    Write-Host "✓ 모든 필수 요구사항이 충족되었습니다!" -ForegroundColor Green
} else {
    Write-Host "✗ 다음 필수 확장이 누락되었습니다:" -ForegroundColor Red
    foreach ($ext in $missingRequired) {
        Write-Host "  - $ext" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "설치 가이드: /guide/php-installation-windows.md" -ForegroundColor Yellow
}

if ($missingOptional.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠ 다음 선택 확장이 누락되었습니다 (권장):" -ForegroundColor Yellow
    foreach ($ext in $missingOptional) {
        Write-Host "  - $ext" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Docker environment provides all requirements automatically." -ForegroundColor Cyan
Write-Host "To use Docker: docker-compose up -d" -ForegroundColor Cyan

