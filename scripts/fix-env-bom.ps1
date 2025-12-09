# .env 파일 BOM 제거 스크립트

Write-Host "Checking .env file for BOM..." -ForegroundColor Yellow

if (-not (Test-Path .env)) {
    Write-Host "  .env file not found!" -ForegroundColor Red
    exit 1
}

# 파일 읽기
$bytes = [System.IO.File]::ReadAllBytes("$PWD\.env")

# BOM 확인 (EF BB BF)
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Host "  BOM detected! Removing..." -ForegroundColor Yellow
    
    # 백업 생성
    Copy-Item .env .env.bom-backup -Force
    Write-Host "  Backup created: .env.bom-backup" -ForegroundColor Cyan
    
    # UTF-8 without BOM으로 다시 저장
    $content = [System.IO.File]::ReadAllText("$PWD\.env", [System.Text.Encoding]::UTF8)
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText("$PWD\.env", $content, $utf8NoBom)
    
    Write-Host "  ✓ BOM removed successfully!" -ForegroundColor Green
} else {
    Write-Host "  ✓ No BOM found - file is OK" -ForegroundColor Green
}

Write-Host ""
Write-Host "Verification:" -ForegroundColor Cyan
$verifyBytes = [System.IO.File]::ReadAllBytes("$PWD\.env")
if ($verifyBytes.Length -ge 3 -and $verifyBytes[0] -eq 0xEF -and $verifyBytes[1] -eq 0xBB -and $verifyBytes[2] -eq 0xBF) {
    Write-Host "  ✗ BOM still present" -ForegroundColor Red
} else {
    Write-Host "  ✓ No BOM - file is ready for Docker" -ForegroundColor Green
}

Write-Host ""

