# .env 파일 생성 스크립트

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

Write-Host "Creating .env file..." -ForegroundColor Yellow

if (Test-Path .env) {
    Write-Host "  .env file already exists. Creating backup..." -ForegroundColor Yellow
    Copy-Item .env .env.backup -Force
    Write-Host "  Backup created: .env.backup" -ForegroundColor Green
}

# UTF-8 without BOM으로 저장 (Docker 호환)
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText((Resolve-Path .env -ErrorAction SilentlyContinue), $envContent, $utf8NoBom)
if (-not (Test-Path .env)) {
    [System.IO.File]::WriteAllText("$PWD\.env", $envContent, $utf8NoBom)
}

Write-Host ""
Write-Host "✓ .env file created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Laravel 프로젝트 초기화 후 APP_KEY 생성:" -ForegroundColor White
Write-Host "     php artisan key:generate" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. 데이터베이스 생성 (선택사항):" -ForegroundColor White
Write-Host "     MariaDB에 ipx_framework 데이터베이스가 자동 생성됩니다." -ForegroundColor Yellow
Write-Host ""

