<# Startet ein Skript, schreibt Log und Laufanzeige. Aufruf: lauf.ps1 -Name <name> -Skript <pfad> #>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]$Name,
    [Parameter(Mandatory = $true)] [string]$Skript
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($Name) -or [string]::IsNullOrWhiteSpace($Skript)) {
    [Console]::Error.WriteLine('Aufruf: lauf.ps1 -Name <name> -Skript <pfad>')
    exit 2
}
if ($Name -notmatch '^[A-Za-z0-9._-]+$') {
    [Console]::Error.WriteLine("lauf.ps1: ungültiger Name '$Name', erlaubt ist nur [A-Za-z0-9._-]+")
    exit 2
}

# ARBEITSORDNER ist für Aufrufe außerhalb der Aufgabenplanung.
if ($env:ARBEITSORDNER) {
    if (-not (Test-Path $env:ARBEITSORDNER -PathType Container)) {
        [Console]::Error.WriteLine("lauf.ps1: ARBEITSORDNER '$($env:ARBEITSORDNER)' nicht erreichbar")
        exit 2
    }
    Set-Location $env:ARBEITSORDNER
}

# Die Aufgabenplanung übernimmt das Terminal-PATH nicht zuverlässig.
$lokalerBin = Join-Path $env:USERPROFILE '.local\bin'
$env:PATH = "$lokalerBin;$env:PATH"
$root = Split-Path $PSScriptRoot -Parent
$logs = Join-Path $root 'betrieb\logs'
$anzeige = Join-Path $root 'betrieb\laufanzeige.md'
New-Item -ItemType Directory -Force -Path $logs | Out-Null
New-Item -ItemType File -Force -Path $anzeige | Out-Null

$log = Join-Path $logs "$Name.log"
$stempel = Get-Date -Format 'yyyy-MM-dd HH:mm'
Add-Content -Path $log -Value "=== $stempel START: Job $Name, Skript $(Split-Path $Skript -Leaf) ==="
function Schuetzen([string]$Text) {
    if ($null -eq $Text) { return '' }
    $Text = $Text -replace '\bsk-[A-Za-z0-9_-]+', '[MASKIERT]'
    $Text = $Text -replace '(?i)\bBearer\s+[A-Za-z0-9._~+/-]+=*', 'Bearer [MASKIERT]'
    return $Text -replace '(?i)\b(api[_-]?key|token|secret|password)\s*[:=]\s*\S+', '$1=[MASKIERT]'
}
try {
    & $Skript *>> $log
    $rc = $LASTEXITCODE
    if ($null -eq $rc) { $rc = 0 }
}
catch {
    Add-Content -Path $log -Value (Schuetzen $_.Exception.Message)
    $rc = 1
}

if ($rc -eq 0) {
    Add-Content -Path $anzeige -Value "$stempel | $Name | OK"
}
else {
    $letzteZeile = Schuetzen (Get-Content -Path $log -Tail 1 -ErrorAction SilentlyContinue)
    if ($letzteZeile.Length -gt 200) { $letzteZeile = $letzteZeile.Substring(0, 200) }
    Add-Content -Path $anzeige -Value "${stempel} | $Name | FEHLER | Exitcode ${rc}: $letzteZeile"
}
exit $rc
