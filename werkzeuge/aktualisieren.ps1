<#
  Holt die neueste Fassung des Werkzeugkastens. Git-Repos werden nur per
  Fast-Forward aktualisiert; sonst wird das öffentliche ZIP geladen. Eigene
  Änderungen werden vor dem Überschreiben als .vor-update-<datum> gesichert.
#>
[CmdletBinding()]
param(
    [string]$Archiv,
    [string]$Kennung,
    [switch]$Pruefen
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$conf = Join-Path $PSScriptRoot 'aktualisieren.conf'
if (-not (Test-Path $conf)) { Write-Error "Fehler: Einstellungsdatei fehlt: $conf"; exit 1 }
$werte = @{}
Get-Content $conf | ForEach-Object { if ($_ -match '^([^=]+)=(.*)$') { $werte[$matches[1]] = $matches[2] } }
$repo = $werte['REPO']; $standOrdner = $werte['STAND_ORDNER']; $schutz = $werte['SCHUTZ']; $danach = $werte['DANACH']
if (-not $repo -or -not $standOrdner) { Write-Error 'Fehler: REPO oder STAND_ORDNER fehlt in aktualisieren.conf'; exit 1 }
$betrieb = Join-Path $root $standOrdner
$stand = Join-Path $betrieb 'stand.txt'
$liste = Join-Path $betrieb 'stand-dateien.txt'
$heute = Get-Date -Format 'yyyyMMdd'
New-Item -ItemType Directory -Force -Path $betrieb | Out-Null

$alt = 'unbekannt'
if (Test-Path $stand) { $alt = (Get-Content $stand -First 1).Split(' ')[0] }

if ((Test-Path (Join-Path $root '.git')) -and (Get-Command git -ErrorAction SilentlyContinue)) {
    & git -C $root rev-parse | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $alt = (& git -C $root rev-parse --short HEAD).Trim()
        if ($Pruefen) {
            $neu = if ($Kennung) { $Kennung } else { (& git -C $root ls-remote origin HEAD | Select-Object -First 1).Substring(0,7) }
            if (-not $neu) { Write-Error 'Fehler: neuesten Git-Stand nicht abrufbar.'; exit 1 }
            Write-Output "STAND $alt $neu"
            if ($alt -eq $neu) { exit 0 } else { exit 10 }
        }
        & git -C $root pull --ff-only
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        $neu = (& git -C $root rev-parse --short HEAD).Trim()
        Set-Content -Encoding UTF8 -Path $stand -Value "$neu $(Get-Date -Format 'dd.MM.yyyy HH:mm') git"
        Write-Output "Stand vorher: $alt"
        Write-Output "Stand jetzt:  $neu"
        if ($alt -ne $neu) {
            Write-Output 'Geänderte Dateien:'
            & git -C $root diff --name-status $alt $neu | ForEach-Object { "  $_" }
            if ($danach) { Write-Output "Danach: $danach" }
        }
        else { Write-Output 'Keine Änderungen.' }
        Write-Output "STAND $alt $neu"
        exit 0
    }
}

$temp = Join-Path ([IO.Path]::GetTempPath()) "maschinenraum-$([guid]::NewGuid())"
try {
    New-Item -ItemType Directory -Path $temp | Out-Null
    if (-not $Kennung) {
        try { $Kennung = (Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/$repo/commits/main" -TimeoutSec 15 -Headers @{ 'User-Agent' = 'aktualisieren' }).sha.Substring(0,7) }
        catch { Write-Error 'Fehler: neueste Kennung von GitHub nicht abrufbar; nichts wurde verändert.'; exit 1 }
    }
    $neu = $Kennung
    if ($Pruefen) { Write-Output "STAND $alt $neu"; if ($alt -eq $neu) { exit 0 } else { exit 10 } }
    $zip = Join-Path $temp 'archiv'
    if ($Archiv -and (Test-Path $Archiv -PathType Leaf)) { Copy-Item -LiteralPath $Archiv -Destination $zip }
    elseif ($Archiv) { Invoke-WebRequest -UseBasicParsing -Uri $Archiv -OutFile $zip }
    else { Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/$repo/archive/$Kennung.zip" -OutFile $zip }
    Expand-Archive -Path $zip -DestinationPath $temp -Force
    $quelle = Get-ChildItem -Path $temp -Directory | Where-Object { $_.Name -notmatch '^maschinenraum-[0-9a-f-]+$' } | Select-Object -First 1
    if (-not $quelle) { throw 'Archiv enthält keinen Werkzeugkasten' }
    $geaendert = @(); $gesichert = @(); $neufassungen = @()
    $bekannt = @{}
    if (Test-Path $liste) {
        Get-Content $liste | ForEach-Object {
            $felder = $_ -split ' ', 2
            if ($felder.Count -eq 2) { $bekannt[$felder[1]] = $felder[0] }
        }
    }
    Get-ChildItem -Path $quelle.FullName -File -Recurse | ForEach-Object {
        $rel = $_.FullName.Substring($quelle.FullName.Length).TrimStart('\', '/')
        if ($rel -like "$standOrdner\*" -or $rel -like "$standOrdner/*") { return }
        $ziel = Join-Path $root $rel
        $geschuetzt = $false; foreach ($muster in ($schutz -split ' ')) { if ($muster.EndsWith('/') -and $rel.StartsWith($muster)) { $geschuetzt = $true }; if ($rel -eq $muster) { $geschuetzt = $true } }
        if ($geschuetzt -and (Test-Path $ziel)) { $neuHash = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash.ToLowerInvariant(); if (((Get-FileHash -Algorithm SHA256 -Path $ziel).Hash.ToLowerInvariant() -ne $neuHash) -and (-not $bekannt.ContainsKey($rel) -or $bekannt[$rel] -ne $neuHash)) { Copy-Item $_.FullName "$ziel.neu-$heute"; $neufassungen += "$rel.neu-$heute" }; return }
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
    Get-ChildItem -Path $quelle.FullName -Force | Where-Object { $_.Name -ne $standOrdner } | Copy-Item -Destination $root -Recurse -Force
    $pruefsummen = Get-ChildItem -Path $quelle.FullName -File -Recurse | Where-Object { $_.FullName -notmatch '[/\\]betrieb[/\\]' } | ForEach-Object {
        $rel = $_.FullName.Substring($quelle.FullName.Length).TrimStart('\', '/')
        $hash = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash.ToLowerInvariant()
        "$hash $rel"
    }
    Set-Content -Encoding UTF8 -Path $liste -Value $pruefsummen
    Set-Content -Encoding UTF8 -Path $stand -Value "$neu $(Get-Date -Format 'dd.MM.yyyy HH:mm') archiv"
    Write-Output "Stand vorher: $alt"
    Write-Output "Stand jetzt:  $neu"
    if ($geaendert.Count) { Write-Output 'Geänderte Dateien:'; $geaendert | ForEach-Object { "  $_" } } else { Write-Output 'Keine Änderungen.' }
    if ($gesichert.Count) { Write-Output 'Eigene Änderungen gesichert:'; $gesichert | ForEach-Object { "  $_" } }
    if ($neufassungen.Count) { Write-Output 'Neue Fassung neben deiner Datei, bitte zusammenführen:'; $neufassungen | ForEach-Object { "  $_" } }
    if (($geaendert.Count -or $neufassungen.Count) -and $danach) { Write-Output "Danach: $danach" }
    Write-Output "STAND $alt $neu"
}
finally {
    if (Test-Path $temp) { Remove-Item -Recurse -Force -Path $temp -ErrorAction SilentlyContinue }
}
