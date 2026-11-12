<# Hält die durch den Werkzeugkasten installierte Codex-CLI unter %USERPROFILE%\.local\bin aktuell. #>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ziel = Join-Path $env:USERPROFILE '.local\bin\codex.exe'
$api = 'https://api.github.com/repos/openai/codex/releases/latest'
if (-not (Test-Path $ziel -PathType Leaf)) {
    $codex = Get-Command 'codex' -ErrorAction SilentlyContinue
    if ($codex) { Write-Output "OK codex liegt unter $($codex.Source), nicht in %USERPROFILE%\.local\bin. Aktualisieren mit dem Werkzeug, das es installiert hat." }
    else { Write-Output 'OK codex ist nicht eingerichtet, nichts zu tun.' }
    exit 0
}

$temp = $null
try {
    $jetzt = (& $ziel --version 2>$null | Select-String -AllMatches '[0-9]+\.[0-9]+\.[0-9]+' | Select-Object -First 1).Matches.Value
    $release = Invoke-RestMethod -UseBasicParsing -Uri $api -TimeoutSec 15 -Headers @{ 'User-Agent' = 'maschinenraum' }
    $asset = $release.assets | Where-Object { $_.name -match 'x86_64-pc-windows-msvc\.zip$' } | Select-Object -First 1
    if (-not $asset) { throw 'Windows-Archiv in der neuesten Veröffentlichung (noch) nicht gefunden, beim nächsten Lauf erneut' }
    $neueste = $release.tag_name -replace '^[^0-9]*', ''
    if ($jetzt -eq $neueste) { Write-Output "OK codex $jetzt ist aktuell"; exit 0 }
    $temp = Join-Path ([IO.Path]::GetTempPath()) "codex-$([guid]::NewGuid())"
    New-Item -ItemType Directory -Path $temp | Out-Null
    $zip = Join-Path $temp 'codex.zip'
    Invoke-WebRequest -UseBasicParsing -Uri $asset.browser_download_url -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $temp -Force
    $neu = Get-ChildItem -Path $temp -Recurse -File -Filter 'codex.exe' | Select-Object -First 1
    if (-not $neu) { throw 'im Archiv keine Programmdatei gefunden' }
    & $neu.FullName --version | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'neue Version startet nicht, alte bleibt' }
    Copy-Item -Path $ziel -Destination "$ziel.vorher" -Force
    Copy-Item -Path $neu.FullName -Destination $ziel -Force
    Write-Output "OK codex von $(if ($jetzt) { $jetzt } else { 'unbekannt' }) auf $neueste aktualisiert (alte Fassung: $ziel.vorher)"
}
catch {
    [Console]::Error.WriteLine("FEHLER codex: $($_.Exception.Message)")
    exit 1
}
finally {
    if ($temp -and (Test-Path $temp)) { Remove-Item -Recurse -Force -Path $temp }
}
