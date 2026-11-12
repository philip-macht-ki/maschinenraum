<# Startet einen Befehl, schreibt Log und Laufanzeige. Aufruf: lauf.ps1 <name> -- <befehl> [argumente] #>
[CmdletBinding()]
param([Parameter(Mandatory, Position=0)][ValidatePattern('^[A-Za-z0-9._-]+$')][string]$Name, [Parameter(Mandatory, Position=1)][string]$Trenner, [Parameter(ValueFromRemainingArguments=$true)][string[]]$Befehl)
$ErrorActionPreference = 'Stop'
if ($Trenner -ne '--' -or -not $Befehl) { throw 'Aufruf: lauf.ps1 <name> -- <befehl> [argumente]' }
if ($env:ARBEITSORDNER) { if (-not (Test-Path $env:ARBEITSORDNER)) { throw "ARBEITSORDNER '$env:ARBEITSORDNER' nicht erreichbar" }; Set-Location $env:ARBEITSORDNER }
$root = Split-Path $PSScriptRoot -Parent; $logs = Join-Path $root 'betrieb\logs'; $anzeige = Join-Path $root 'betrieb\laufanzeige.md'; New-Item -ItemType Directory -Force $logs | Out-Null; New-Item -ItemType File -Force $anzeige | Out-Null
$log = Join-Path $logs "$Name.log"; $stempel = Get-Date -Format 'yyyy-MM-dd HH:mm'; Add-Content $log "=== $stempel START: $($Befehl -join ' ') ==="
try { $programm = $Befehl[0]; $argumente = if ($Befehl.Count -gt 1) { $Befehl[1..($Befehl.Count - 1)] } else { @() }; & $programm $argumente *>> $log; $rc = $LASTEXITCODE; if ($null -eq $rc) { $rc = 0 } } catch { Add-Content $log $_.Exception.Message; $rc = 1 }
if ($rc -eq 0) { Add-Content $anzeige "$stempel | $Name | OK" } else { $letzte = (Get-Content $log -Tail 1 -ErrorAction SilentlyContinue); Add-Content $anzeige "$stempel | $Name | FEHLER | Exitcode $rc: $letzte" }
exit $rc
