<# Ampel über den Stand des Werkzeugkastens unter Windows. Aufruf: powershell -NoProfile -File pruefen.ps1 #>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$rot = $false
$gelb = $false

function Zeile([string]$Ampel, [string]$Text) {
    Write-Output "$Ampel  $Text"
}

function Pruefe-Befehl([string]$Name, [bool]$Pflicht = $false) {
    $befehl = Get-Command $Name -ErrorAction SilentlyContinue
    if ($befehl) {
        Zeile 'GRUEN' "$Name gefunden ($($befehl.Source))"
    }
    elseif ($Pflicht) {
        Zeile 'ROT  ' "$Name fehlt"
        $script:rot = $true
    }
    else {
        Zeile 'GELB ' "$Name fehlt (freiwillig)"
        $script:gelb = $true
    }
}

Write-Output "Claude-Profi-Setup, Stand $(Get-Date -Format 'dd.MM.yyyy HH:mm')"
Write-Output ''

# Windows hat keinen gemeinsamen pmset-Status; Zeitpläne brauchen einen eingeschalteten Rechner.
Zeile 'INFO ' "Rechner: $env:COMPUTERNAME"
Zeile 'INFO ' 'Energie: unter Windows nicht automatisch geprüft; Zeitpläne laufen nur, solange der Rechner eingeschaltet ist.'

try {
    $computer = Get-CimInstance Win32_ComputerSystem
    Zeile 'INFO ' "Angemeldeter Benutzer: $($computer.UserName)"
}
catch {
    Zeile 'GELB ' 'Angemeldeter Benutzer nicht automatisch feststellbar (freiwillig)'
    $gelb = $true
}
try {
    Get-WindowsBackup -ErrorAction Stop | Out-Null
    Zeile 'GRUEN' 'Backup: Windows-Sicherung ist eingerichtet'
}
catch {
    Zeile 'GELB ' 'Backup: nicht automatisch feststellbar (freiwillig, aber empfohlen)'
    $gelb = $true
}

Pruefe-Befehl 'git'
Pruefe-Befehl 'uv'
Pruefe-Befehl 'graphify'
Pruefe-Befehl 'claude'
Pruefe-Befehl 'codex'
Pruefe-Befehl 'ollama'

$betrieb = Join-Path $root 'betrieb'
if (Test-Path $betrieb -PathType Container) {
    $testdatei = Join-Path $betrieb ".schreibtest-$([guid]::NewGuid())"
    try {
        [IO.File]::WriteAllText($testdatei, '')
        Remove-Item $testdatei -Force
        Zeile 'GRUEN' 'Ordner betrieb/ ist beschreibbar'
    }
    catch {
        Zeile 'ROT  ' 'Ordner betrieb/ ist nicht beschreibbar'
        $rot = $true
    }
}
else {
    Zeile 'ROT  ' 'Ordner betrieb/ fehlt'
    $rot = $true
}

$agents = Join-Path $env:USERPROFILE '.claude\agents'
if (Test-Path $agents -PathType Container) {
    $anzahl = @(Get-ChildItem $agents -Filter '*.md' -File -ErrorAction SilentlyContinue).Count
    if ($anzahl -gt 0) {
        Zeile 'GRUEN' "$anzahl Helfer in %USERPROFILE%\.claude\agents"
    }
    else {
        Zeile 'GELB ' '.claude\agents ist da, aber leer'
        $gelb = $true
    }
}
else {
    Zeile 'GELB ' '.claude\agents fehlt noch (die Helfer kommen in Teil 1)'
    $gelb = $true
}

if ((Get-Command 'codex-do' -ErrorAction SilentlyContinue) -or (Test-Path (Join-Path $env:USERPROFILE '.local\bin\codex-do.exe'))) {
    Zeile 'GRUEN' 'codex-do gefunden'
}
else {
    Zeile 'GELB ' 'codex-do fehlt (freiwillig, kommt in Teil 2)'
    $gelb = $true
}

if (Get-Command 'ollama' -ErrorAction SilentlyContinue) {
    try {
        Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1:11434/api/tags' -TimeoutSec 2 | Out-Null
        Zeile 'GRUEN' 'ollama läuft'
    }
    catch {
        Zeile 'GELB ' 'ollama installiert, aber der Dienst antwortet nicht (freiwillig)'
        $gelb = $true
    }
}

Write-Output ''
if ($rot) {
    Write-Output 'Gesamturteil: ROT, etwas Nötiges fehlt, siehe oben.'
    exit 1
}
if ($gelb) {
    Write-Output 'Gesamturteil: GELB, läuft, freiwillige Teile fehlen noch.'
    exit 0
}
Write-Output 'Gesamturteil: GRUEN.'
exit 0
