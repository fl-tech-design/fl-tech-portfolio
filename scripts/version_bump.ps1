# scripts/version-bump.ps1
# Inkrementiert Version in hugo.toml und aktualisiert buildDate

param(
    [ValidateSet("patch", "minor", "major")]
    [string]$Type = "patch",
    [switch]$NoCommit
)

$tomlPath = "hugo.toml"
if (-not (Test-Path $tomlPath)) {
    Write-Error "hugo.toml nicht gefunden im aktuellen Verzeichnis"
    exit 1
}

$content = Get-Content $tomlPath -Raw

# Version auslesen
if ($content -match 'version\s*=\s*"(\d+)\.(\d+)\.(\d+)"') {
    $major = [int]$matches[1]
    $minor = [int]$matches[2]
    $patch = [int]$matches[3]
    
    switch ($Type) {
        "major" { $major++; $minor = 0; $patch = 0 }
        "minor" { $minor++; $patch = 0 }
        "patch" { $patch++ }
    }
    $newVersion = "$major.$minor.$patch"
} else {
    Write-Warning "Keine Version in hugo.toml gefunden, setze auf 0.1.0"
    $newVersion = "0.1.0"
}

# buildDate aktualisieren
$newDate = Get-Date -Format "yyyy-MM-dd"

# TOML updaten
$content = $content -replace 'version\s*=\s*"[^"]+"', "version = `"$newVersion`""
$content = $content -replace 'buildDate\s*=\s*"[^"]+"', "buildDate = `"$newDate`""

# Speichern
Set-Content -Path $tomlPath -Value $content -Encoding UTF8
Write-Host "Version aktualisiert: v$newVersion - Build: $newDate" -ForegroundColor Green

if (-not $NoCommit) {
    Write-Host "Git-Commit erstellen..." -ForegroundColor Yellow
    git add $tomlPath
    git commit -m "Release: Version $newVersion

- Version bump ($Type) in hugo.toml
- Build-Date: $newDate

Files: hugo.toml"
    Write-Host "Commit erstellt" -ForegroundColor Green
    
    $answer = Read-Host "Jetzt pushen? (y/N)"
    if ($answer -eq "y" -or $answer -eq "Y") {
        git push origin main
        Write-Host "Gepusht" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Tipp: Naechster Server-Start mit .\scripts\hugo-restart.ps1" -ForegroundColor Cyan