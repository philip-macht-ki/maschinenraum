<#
  Holt die neueste Fassung des Werkzeugkastens. Git-Repos werden nur per
  Fast-Forward aktualisiert; sonst wird das öffentliche ZIP geladen. Eigene
  Änderungen werden vor dem Überschreiben als .vor-update-<datum> gesichert.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$betrieb = Join-Path $root 'betrieb'
$stand = Join-Path $betrieb 'stand.txt'
$liste = Join-Path $betrieb 'stand-dateien.txt'
$heute = Get-Date -Format 'yyyyMMdd'
$repo = $env:MASCHINENRAUM_REPO
if (-not $repo) { $repo = 'philip-macht-ki/maschinenraum' }
New-Item -ItemType Directory -Force -Path $betrieb | Out-Null

$alt = 'unbekannt'
if (Test-Path $stand) { $alt = (Get-Content $stand -First 1).Split(' ')[0] }

if ((Test-Path (Join-Path $root '.git')) -and (Get-Command git -ErrorAction SilentlyContinue)) {
    & git -C $root rev-parse | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $alt = (& git -C $root rev-parse --short HEAD).Trim()
        & git -C $root pull --ff-only
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        $neu = (& git -C $root rev-parse --short HEAD).Trim()
        Set-Content -Encoding UTF8 -Path $stand -Value "$neu $(Get-Date -Format 'dd.MM.yyyy HH:mm') git"
        Write-Output "Stand vorher: $alt"
        Write-Output "Stand jetzt:  $neu"
        if ($alt -ne $neu) {
            Write-Output 'Geänderte Dateien:'
            & git -C $root diff --name-status $alt $neu | ForEach-Object { "  $_" }
        }
        else { Write-Output 'Keine Änderungen.' }
        exit 0
    }
}

$temp = Join-Path ([IO.Path]::GetTempPath()) "maschinenraum-$([guid]::NewGuid())"
try {
    New-Item -ItemType Directory -Path $temp | Out-Null
    $api = "https://api.github.com/repos/$repo/commits/main"
    try {
        $commit = Invoke-RestMethod -UseBasicParsing -Uri $api -TimeoutSec 15 -Headers @{ 'User-Agent' = 'maschinenraum' }
        $neu = $commit.sha.Substring(0, 7)
    }
    catch { $neu = 'unbekannt' }
    $ref = if ($neu -eq 'unbekannt') { 'main' } else { $neu }
    $zip = Join-Path $temp 'archiv.zip'
    Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/$repo/archive/$ref.zip" -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $temp -Force
    $quelle = Get-ChildItem -Path $temp -Directory | Where-Object { $_.Name -notmatch '^maschinenraum-[0-9a-f-]+$' } | Select-Object -First 1
    if (-not $quelle) { throw 'Archiv enthält keinen Werkzeugkasten' }
    $geaendert = @()
    $gesichert = @()
    $bekannt = @{}
    if (Test-Path $liste) {
        Get-Content $liste | ForEach-Object {
            $felder = $_ -split ' ', 2
            if ($felder.Count -eq 2) { $bekannt[$felder[1]] = $felder[0] }
        }
    }
    Get-ChildItem -Path $quelle.FullName -File -Recurse | ForEach-Object {
        $rel = $_.FullName.Substring($quelle.FullName.Length).TrimStart('\', '/')
        if ($rel -like 'betrieb\*' -or $rel -like 'betrieb/*') { return }
        $ziel = Join-Path $root $rel
        if (-not (Test-Path $ziel)) { $geaendert += "neu       $rel"; return }
        $jetzt = (Get-FileHash -Algorithm SHA256 -Path $ziel).Hash.ToLowerInvariant()
        $neuHash = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash.ToLowerInvariant()
        if ($jetzt -eq $neuHash) { return }
        $geaendert += "geändert  $rel"
        if (-not $bekannt.ContainsKey($rel) -or $bekannt[$rel] -ne $jetzt) {
            Copy-Item -Path $ziel -Destination "$ziel.vor-update-$heute"
            $gesichert += "$rel.vor-update-$heute"
        }
    }
    Get-ChildItem -Path $quelle.FullName -Force | Where-Object { $_.Name -ne 'betrieb' } | Copy-Item -Destination $root -Recurse -Force
    $pruefsummen = Get-ChildItem -Path $quelle.FullName -File -Recurse | Where-Object { $_.FullName -notmatch '[/\\]betrieb[/\\]' } | ForEach-Object {
        $rel = $_.FullName.Substring($quelle.FullName.Length).TrimStart('\', '/')
        $hash = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash.ToLowerInvariant()
        "$hash $rel"
    }
    Set-Content -Encoding UTF8 -Path $liste -Value $pruefsummen
    Set-Content -Encoding UTF8 -Path $stand -Value "$neu $(Get-Date -Format 'dd.MM.yyyy HH:mm') archiv"
    Write-Output "Werkzeugkasten aktualisiert: $root"
    Write-Output "Stand vorher: $alt"
    Write-Output "Stand jetzt:  $neu"
    if ($geaendert.Count) { Write-Output 'Geänderte Dateien:'; $geaendert | ForEach-Object { "  $_" } } else { Write-Output 'Keine Änderungen.' }
    if ($gesichert.Count) { Write-Output 'Eigene Änderungen gesichert, bevor sie überschrieben wurden:'; $gesichert | ForEach-Object { "  $_" } }
}
finally {
    if (Test-Path $temp) { Remove-Item -Recurse -Force -Path $temp }
}
