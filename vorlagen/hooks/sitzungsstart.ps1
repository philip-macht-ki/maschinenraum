<# SessionStart-Hook: zeigt nur seit dem letzten Sitzungsstart neue FEHLER-Zeilen. #>
[CmdletBinding()]
param()

$betrieb = Join-Path $env:USERPROFILE 'maschinenraum\betrieb'
$merker = Join-Path $betrieb '.sitzungsstart-gesehen'
New-Item -ItemType Directory -Force -Path $betrieb | Out-Null
New-Item -ItemType File -Force -Path $merker | Out-Null
$anzeigen = @(Join-Path $betrieb 'laufanzeige.md')
$alt = @{}
Get-Content $merker | ForEach-Object {
    $teile = $_.Split("`t", 2)
    if ($teile.Count -eq 2 -and $teile[1] -match '^\d+$') { $alt[$teile[0]] = [int]$teile[1] }
}
$neu = @()
foreach ($datei in $anzeigen) {
    if (-not (Test-Path $datei -PathType Leaf)) { continue }
    $zeilen = @(Get-Content $datei)
    $vorher = if ($alt.ContainsKey($datei)) { $alt[$datei] } else { 0 }
    if ($zeilen.Count -gt $vorher) {
        $fehler = $zeilen[$vorher..($zeilen.Count - 1)] | Where-Object { $_ -like '*| FEHLER |*' } | Select-Object -Last 10
        if ($fehler) { Write-Output "Neue FEHLER in $datei seit der letzten Sitzung:"; $fehler }
    }
    $neu += "$datei`t$($zeilen.Count)"
}
# Pfade, die diesmal nicht lesbar waren, bleiben im Merker erhalten.
Get-Content $merker | ForEach-Object { if ($_ -and ($_.Split("`t", 2)[0] -notin $anzeigen)) { $neu += $_ } }
$neu | Set-Content -Encoding UTF8 -Path $merker
exit 0
