# .env 파일 Multi-Database 설정으로 업데이트 스크립트

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

# -------------------------------------------
# [Database 1] Master DB (SSO/Auth)
# -------------------------------------------
DB_CONNECTION=mysql_master
DB_MASTER_HOST=mariadb
DB_MASTER_PORT=3306
DB_MASTER_DATABASE=ipx_master
DB_MASTER_USERNAME=ipx_app
DB_MASTER_PASSWORD=strong_password

# -------------------------------------------
# [Database 2] VR Product DB (Recording/AI)
# -------------------------------------------
DB_VR_HOST=mariadb
DB_VR_PORT=3306
DB_VR_DATABASE=ipx_vr
DB_VR_USERNAME=ipx_app
DB_VR_PASSWORD=strong_password

# -------------------------------------------
# [Legacy] 기존 MariaDB 서비스 (참고용)
# -------------------------------------------
# DB_LEGACY_HOST=127.0.0.1
# DB_LEGACY_PORT=3306
# DB_LEGACY_DATABASE=ipx_framework
# DB_LEGACY_USERNAME=root
# DB_LEGACY_PASSWORD=st5300!@#

# Redis Connection (Docker 사용 시)
REDIS_HOST=redis
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

Write-Host "Updating .env file for Multi-Database setup..." -ForegroundColor Yellow

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
Write-Host "✓ .env file updated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Multi-Database Configuration:" -ForegroundColor Cyan
Write-Host "  - Master DB (ipx_master): SSO/Auth" -ForegroundColor White
Write-Host "  - VR DB (ipx_vr): Recording/AI" -ForegroundColor White
Write-Host ""
Write-Host "Connection Info:" -ForegroundColor Cyan
Write-Host "  - Docker Internal: mariadb:3306" -ForegroundColor White
Write-Host "  - External (DBeaver): 127.0.0.1:3307" -ForegroundColor White
Write-Host ""

