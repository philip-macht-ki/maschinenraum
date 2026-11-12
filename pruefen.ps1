<#! Ampel ueber den Stand des Werkzeugkastens unter Windows. Aufruf: powershell -File pruefen.ps1 #>
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot; $rot = $false; $gelb = $false
function Zeile([string]$Ampel, [string]$Text) { Write-Output "$Ampel  $Text" }
function Pruefe-Befehl([string]$Name, [bool]$Pflicht = $false) {
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if ($cmd) { Zeile 'GRUEN' "$Name gefunden ($($cmd.Source))" }
  elseif ($Pflicht) { Zeile 'ROT  ' "$Name fehlt"; $script:rot = $true }
  else { Zeile 'GELB ' "$Name fehlt (freiwillig)"; $script:gelb = $true }
}
Write-Output "Claude-Profi-Setup, Stand $(Get-Date -Format 'dd.MM.yyyy HH:mm')"; Write-Output ''
Zeile 'INFO ' "Rechner: $env:COMPUTERNAME"
try { $status = Get-CimInstance Win32_ComputerSystem; Zeile 'INFO ' "Angemeldeter Benutzer: $($status.UserName)" } catch {}
try { $backup = Get-WindowsBackup -ErrorAction Stop; Zeile 'GRUEN' 'Backup: Windows-Sicherung ist eingerichtet' } catch { Zeile 'GELB ' 'Backup: nicht automatisch feststellbar (freiwillig, aber empfohlen)'; $gelb = $true }
foreach ($name in 'git','uv','graphify','claude','codex','ollama') { Pruefe-Befehl $name }
if (Test-Path (Join-Path $root 'betrieb') -PathType Container) { Zeile 'GRUEN' 'Ordner betrieb/ ist vorhanden' } else { Zeile 'ROT  ' 'Ordner betrieb/ fehlt'; $rot = $true }
$agents = Join-Path $env:USERPROFILE '.claude\agents'
if (Test-Path $agents) { $anzahl = @(Get-ChildItem $agents -Filter '*.md' -ErrorAction SilentlyContinue).Count; if ($anzahl) { Zeile 'GRUEN' "$anzahl Helfer in %USERPROFILE%\.claude\agents" } else { Zeile 'GELB ' '.claude\agents ist da, aber leer'; $gelb = $true } } else { Zeile 'GELB ' '.claude\agents fehlt noch'; $gelb = $true }
if (Get-Command ollama -ErrorAction SilentlyContinue) { try { Invoke-RestMethod 'http://127.0.0.1:11434/api/tags' -TimeoutSec 2 | Out-Null; Zeile 'GRUEN' 'ollama läuft' } catch { Zeile 'GELB ' 'ollama installiert, aber der Dienst antwortet nicht'; $gelb = $true } }
Write-Output ''
if ($rot) { Write-Output 'Gesamturteil: ROT, etwas Nötiges fehlt, siehe oben.'; exit 1 }
if ($gelb) { Write-Output 'Gesamturteil: GELB, läuft, freiwillige Teile fehlen noch.'; exit 0 }
Write-Output 'Gesamturteil: GRUEN.'
