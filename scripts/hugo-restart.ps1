# scripts/hugo-restart.ps1
# Leert Hugo-Cache und startet Server neu

param(
    [string]$Port = "1313"
)

Write-Host "Hugo-Cache leeren..." -ForegroundColor Yellow

Remove-Item -Path ".hugo_build.lock" -ErrorAction SilentlyContinue

Write-Host "Cache geleert" -ForegroundColor Green
Write-Host "Hugo-Server starten (Port $Port)..." -ForegroundColor Cyan
Write-Host "Server mit Ctrl+C beenden" -ForegroundColor Gray
Write-Host ""

hugo server --port $Port --disableFastRender --ignoreCache