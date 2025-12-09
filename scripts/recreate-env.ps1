# .env 파일 재생성 스크립트 (Docker 호환)

$envContent = @"
APP_NAME=IPX-Framework
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_TIMEZONE=Asia/Seoul
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

# MariaDB Connection (기존 MariaDB 10.11.7 사용)
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ipx_framework
DB_USERNAME=root
DB_PASSWORD=st5300!@#

# Redis Connection (Docker 사용 시)
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
REDIS_DB=0

CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

BROADCAST_DRIVER=log
FILESYSTEM_DISK=local

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

# AI Integration (향후 설정)
STT_API_URL=
STT_API_KEY=
LLM_API_URL=
LLM_API_KEY=

# Security
SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1
SESSION_DOMAIN=localhost

# Horizon (Queue Dashboard)
HORIZON_PREFIX=horizon
HORIZON_BALANCE=auto
HORIZON_MAX_PROCESSES=10

# Performance
OPCACHE_ENABLED=true
"@

Write-Host "Recreating .env file (Docker compatible)..." -ForegroundColor Yellow

# 백업 생성
if (Test-Path .env) {
    Copy-Item .env .env.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss') -Force
    Write-Host "  Backup created" -ForegroundColor Cyan
}

# Unix 스타일 줄바꿈으로 변환 (LF only)
$envContent = $envContent -replace "`r`n", "`n" -replace "`r", "`n"

# UTF-8 without BOM으로 저장
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText("$PWD\.env", $envContent, $utf8NoBom)

Write-Host ""
Write-Host "✓ .env file recreated successfully!" -ForegroundColor Green
Write-Host "  - UTF-8 without BOM" -ForegroundColor White
Write-Host "  - Unix line endings (LF)" -ForegroundColor White
Write-Host "  - Docker compatible" -ForegroundColor White
Write-Host ""

# 검증
$verifyBytes = [System.IO.File]::ReadAllBytes("$PWD\.env")
if ($verifyBytes.Length -ge 3 -and $verifyBytes[0] -eq 0xEF -and $verifyBytes[1] -eq 0xBB -and $verifyBytes[2] -eq 0xBF) {
    Write-Host "⚠ Warning: BOM still detected" -ForegroundColor Yellow
} else {
    Write-Host "✓ Verification: No BOM detected" -ForegroundColor Green
}

Write-Host ""

