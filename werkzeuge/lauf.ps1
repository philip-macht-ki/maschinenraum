<# Startet einen Befehl, schreibt Log und Laufanzeige. Aufruf: lauf.ps1 <name> -- <befehl> [argumente] #>
[CmdletBinding()]
param(
    [Parameter(Position = 0)] [string]$Name,
    [Parameter(ValueFromRemainingArguments = $true)] [string[]]$Befehl
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($Name) -or -not $Befehl) {
    # PowerShell reserviert -- für seine eigene Parameterverarbeitung.
    [Console]::Error.WriteLine('Aufruf: lauf.ps1 <name> <befehl> [argumente] (das Shell-Trennzeichen -- wird in PowerShell nicht verwendet)')
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
Add-Content -Path $log -Value "=== $stempel START: $($Befehl -join ' ') ==="
try {
    $programm = $Befehl[0]
    $argumente = @()
    if ($Befehl.Count -gt 1) { $argumente = $Befehl[1..($Befehl.Count - 1)] }
    & $programm @argumente *>> $log
    $rc = $LASTEXITCODE
    if ($null -eq $rc) { $rc = 0 }
}
catch {
    Add-Content -Path $log -Value $_.Exception.Message
    $rc = 1
}

if ($rc -eq 0) {
    Add-Content -Path $anzeige -Value "$stempel | $Name | OK"
}
else {
    $letzteZeile = Get-Content -Path $log -Tail 1 -ErrorAction SilentlyContinue
    Add-Content -Path $anzeige -Value "${stempel} | $Name | FEHLER | Exitcode ${rc}: $letzteZeile"
}
exit $rc
