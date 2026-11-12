<#
  Schaut über Laufanzeigen und Aufgabenplanung; meldet Befunde per Windows-Toast.
  Aufruf: waechter.ps1 [-Probe]. MR_TEST=1 schreibt Mitteilungen nur ins Log.
#>
[CmdletBinding()]
param([switch]$Probe)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$betrieb = Join-Path $root 'betrieb'
$logs = Join-Path $betrieb 'logs'
$anzeige = Join-Path $betrieb 'laufanzeige.md'
$conf = Join-Path $betrieb 'waechter.conf'
$befund = Join-Path $betrieb 'waechter.md'
New-Item -ItemType Directory -Force -Path $logs | Out-Null
New-Item -ItemType File -Force -Path $anzeige | Out-Null

$anzeigen = @($anzeige)
$takte = @()
$praefixe = @()
$befunde = @()
if (Test-Path $conf) {
    $nr = 0
    foreach ($zeile in Get-Content $conf) {
        $nr++
        $teile = (($zeile -replace '#.*$').Trim() -split '\s+')
        if (-not $teile[0]) { continue }
        switch ($teile[0]) {
            'anzeige' {
                if ($teile.Count -ne 2) { $befunde += "waechter.conf Zeile ${nr}: 'anzeige <pfad>' braucht genau ein Feld" }
                elseif (-not (Test-Path $teile[1] -PathType Leaf)) { $befunde += "waechter.conf Zeile ${nr}: anzeige-Pfad '$($teile[1])' existiert nicht" }
                else { $anzeigen += $teile[1] }
            }
            'takt' {
                if ($teile.Count -ne 3 -or $teile[2] -notmatch '^\d+$') { $befunde += "waechter.conf Zeile ${nr}: 'takt <name> <stunden>' braucht einen Namen und eine ganze Stundenzahl" }
                else { $takte += ,@($teile[1], [int]$teile[2]) }
            }
            'praefix' {
                if ($teile.Count -ne 2) { $befunde += "waechter.conf Zeile ${nr}: 'praefix <text>' braucht genau ein Feld" }
                else { $praefixe += $teile[1] }
            }
            default { $befunde += "waechter.conf Zeile ${nr}: unbekannte Direktive '$($teile[0])'" }
        }
    }
}

$gestern = (Get-Date).AddDays(-1).ToString('yyyy-MM-dd')
$heute = Get-Date -Format 'yyyy-MM-dd'
$jetzt = Get-Date -Format 'yyyy-MM-dd HH:mm'
# 1. FEHLER-Zeilen seit gestern in allen bekannten Laufanzeigen.
foreach ($datei in $anzeigen) {
    if (-not (Test-Path $datei -PathType Leaf)) { continue }
    foreach ($zeile in Get-Content $datei) {
        if (($zeile.StartsWith($heute) -or $zeile.StartsWith($gestern)) -and $zeile -like '*| FEHLER |*') {
            $befunde += "$(Split-Path $datei -Leaf): $zeile"
        }
    }
}

# 2. Takte: die letzte OK-Zeile jedes Jobs muss frisch genug sein.
foreach ($takt in $takte) {
    $job = $takt[0]
    $stunden = $takt[1]
    $letzter = $null
    foreach ($datei in $anzeigen) {
        if (Test-Path $datei -PathType Leaf) {
            $treffer = Get-Content $datei | Where-Object { $_ -like "*| $job |*" } | Select-Object -Last 1
            if ($treffer) { $letzter = $treffer }
        }
    }
    if (-not $letzter) { $befunde += "${job}: noch nie gelaufen laut Laufanzeige"; continue }
    $zeittext = $letzter.Split('|')[0].Trim()
    try { $zeit = [datetime]::ParseExact($zeittext, 'yyyy-MM-dd HH:mm', [Globalization.CultureInfo]::InvariantCulture) }
    catch { $befunde += "${job}: Zeitstempel '$zeittext' nicht lesbar (erwartet JJJJ-MM-TT SS:MM)"; continue }
    $differenz = [math]::Floor(((Get-Date) - $zeit).TotalHours)
    if ($differenz -gt $stunden) { $befunde += "${job}: letzter Lauf vor ${differenz}h, erwartet spätestens alle ${stunden}h" }
}

# 3. Aufgabenplanung statt launchctl; auf Nicht-Windows ist dies bewusst nicht verfügbar.
if ($praefixe.Count -and $env:OS -eq 'Windows_NT') {
    foreach ($praefix in $praefixe) {
        Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $_.TaskName -like "$praefix*" } | ForEach-Object {
            $info = $_ | Get-ScheduledTaskInfo
            if ($info.LastTaskResult -ne 0) { $befunde += "Aufgabe $($_.TaskName): letzter Exitcode $($info.LastTaskResult)" }
        }
    }
}

# 4. Einmal pro Monat Codex prüfen, sofern die Werkzeugkasten-CLI vorhanden ist.
$merker = Join-Path $betrieb 'codex-geprueft'
$codex = Join-Path $env:USERPROFILE '.local\bin\codex.exe'
if (-not $Probe -and $env:MR_CODEX -ne '0' -and (Test-Path $codex) -and ((-not (Test-Path $merker)) -or ((Get-Date) - (Get-Item $merker).LastWriteTime).TotalDays -gt 30)) {
    $ergebnis = & (Join-Path $PSScriptRoot 'codex-aktualisieren.ps1') 2>&1 | Select-Object -Last 1
    Add-Content -Path (Join-Path $logs 'codex-aktualisieren.log') -Value "$jetzt $ergebnis"
    if ("$ergebnis" -like 'OK*') { New-Item -ItemType File -Force -Path $merker | Out-Null }
    else { $befunde += "Codex-Update: $ergebnis" }
}

@('# Wächter-Befund', "Stand: $jetzt", '') + $(if ($befunde.Count) { $befunde | ForEach-Object { "- $_" } } else { 'Nichts auffaellig.' }) | Set-Content -Encoding UTF8 -Path $befund

function Melden([string]$Titel, [string]$Text) {
    $mitteilungslog = Join-Path $logs 'waechter-mitteilungen.log'
    if ($env:MR_TEST -eq '1') {
        Add-Content -Path $mitteilungslog -Value "${jetzt} MITTEILUNG (Test, nicht ausgelöst): ${Titel}: $Text"
        return
    }
    try {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml("<toast><visual><binding template='ToastGeneric'><text>$Titel</text><text>$Text</text></binding></visual></toast>")
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Windows PowerShell').Show([Windows.UI.Notifications.ToastNotification]::new($xml))
    }
    catch { Add-Content -Path $mitteilungslog -Value "${jetzt} MITTEILUNG FEHLGESCHLAGEN: ${Titel}: $Text" }
}

if ($Probe) { Melden 'Wächter (Probe)' 'Das ist eine Probemeldung von waechter.ps1 --Probe.'; Write-Output 'Probemeldung ausgelöst.'; exit 0 }
if ($befunde.Count) { Melden 'Wächter meldet FEHLER' "$($befunde[0]) (und $($befunde.Count - 1) weitere, siehe betrieb/waechter.md)" }
exit 0
