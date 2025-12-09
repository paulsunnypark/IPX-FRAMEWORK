# IPX-Framework PHP 확장 프로그램 설정 스크립트
# 관리자 권한 PowerShell에서 실행 필요

$phpPath = "D:\IPX-Web\WAS_v3.0\php-8.4.x"
$phpIni = "$phpPath\php.ini"
$phpIniBackup = "$phpPath\php.ini.ipx-backup"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PHP 확장 프로그램 설정" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# php.ini 파일 확인
if (-not (Test-Path $phpIni)) {
    Write-Host "  php.ini 파일을 찾을 수 없습니다: $phpIni" -ForegroundColor Red
    exit 1
}

# 백업 생성
Write-Host "  php.ini 백업 생성 중..." -ForegroundColor Yellow
Copy-Item $phpIni $phpIniBackup -Force
Write-Host "  백업 완료: $phpIniBackup" -ForegroundColor Green

# php.ini 내용 읽기
$iniContent = Get-Content $phpIni -Raw

# 1. OPcache 활성화
Write-Host "  OPcache 활성화 중..." -ForegroundColor Yellow
$iniContent = $iniContent -replace ';zend_extension=opcache', 'zend_extension=opcache'

# 2. intl 확장 활성화
Write-Host "  intl 확장 활성화 중..." -ForegroundColor Yellow
$iniContent = $iniContent -replace ';extension=intl', 'extension=intl'

# 3. OPcache 설정 활성화 및 최적화
Write-Host "  OPcache 설정 최적화 중..." -ForegroundColor Yellow

# OPcache 설정 섹션 찾기 및 활성화
$opcacheSettings = @"
[opcache]
opcache.enable=1
opcache.enable_cli=0
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=20000
opcache.validate_timestamps=0
opcache.revalidate_freq=0
opcache.save_comments=1
opcache.jit_buffer_size=256M
opcache.jit=tracing
"@

# 기존 opcache 섹션을 찾아서 교체
if ($iniContent -match '\[opcache\].*?(?=\[|\Z)') {
    $iniContent = $iniContent -replace '\[opcache\].*?(?=\[|\Z)', $opcacheSettings
} else {
    # opcache 섹션이 없으면 추가
    $iniContent += "`n`n$opcacheSettings"
}

# 4. 메모리 및 업로드 제한 설정
Write-Host "  메모리 및 업로드 제한 설정 중..." -ForegroundColor Yellow
$iniContent = $iniContent -replace '(memory_limit\s*=\s*)\d+M', '${1}512M'
$iniContent = $iniContent -replace '(upload_max_filesize\s*=\s*)\d+M', '${1}100M'
$iniContent = $iniContent -replace '(post_max_size\s*=\s*)\d+M', '${1}100M'
$iniContent = $iniContent -replace '(max_execution_time\s*=\s*)\d+', '${1}300'

# 5. 타임존 설정
Write-Host "  타임존 설정 중..." -ForegroundColor Yellow
if ($iniContent -match 'date\.timezone\s*=') {
    $iniContent = $iniContent -replace 'date\.timezone\s*=.*', 'date.timezone = Asia/Seoul'
} else {
    $iniContent = $iniContent -replace '(\[Date\])', "`$1`ndate.timezone = Asia/Seoul"
}

# php.ini 파일 저장
Set-Content -Path $phpIni -Value $iniContent -Encoding UTF8

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "설정 완료!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "변경 사항:" -ForegroundColor Yellow
Write-Host "  ✓ OPcache 활성화 및 JIT 설정" -ForegroundColor Green
Write-Host "  ✓ intl 확장 활성화" -ForegroundColor Green
Write-Host "  ✓ 메모리 제한: 512M" -ForegroundColor Green
Write-Host "  ✓ 업로드 제한: 100M" -ForegroundColor Green
Write-Host "  ✓ 실행 시간 제한: 300초" -ForegroundColor Green
Write-Host "  ✓ 타임존: Asia/Seoul" -ForegroundColor Green
Write-Host ""
Write-Host "백업 파일: $phpIniBackup" -ForegroundColor Cyan
Write-Host ""
Write-Host "다음 명령으로 확인하세요:" -ForegroundColor Yellow
Write-Host "  D:\IPX-Web\WAS_v3.0\php-8.4.x\php.exe -m" -ForegroundColor White
Write-Host "  D:\IPX-Web\WAS_v3.0\php-8.4.x\php.exe -i | findstr opcache" -ForegroundColor White
Write-Host ""

