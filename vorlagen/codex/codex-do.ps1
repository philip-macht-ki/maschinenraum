# codex-do.ps1: gibt einen Auftrag an Codex und liefert nur das Wesentliche zurueck.
#
#   @'
#   …Auftrag…
#   '@ | codex-do.ps1
#
# Alternativ: codex-do.ps1 -Auftrag '…Auftrag…'
#
# CODEX_HOME wird absichtlich nicht gesetzt: codex nutzt dieselbe Anmeldung
# und Konfiguration wie ein normales `codex login` (Standardort: ~/.codex).
# Das volle Rohprotokoll jedes Laufs liegt in $env:USERPROFILE\.codex-tandem\logs;
# auf stdout kommen nur die letzten kurzen Zeilen der Abschlussantwort.
#
# Stellschrauben:
#   CODEX_SANDBOX   read-only | workspace-write | danger-full-access
#                   (Standard: workspace-write)
#   CODEX_TAIL      wie viele Zeilen zurueckkommen (Standard: 25)
#   CODEX_MODEL     Modell ueberschreiben (Standard: aus der Config)
#   CODEX_IMAGES    Leerzeichengetrennte Bildpfade als Referenzbilder

[CmdletBinding()]
param(
    [Parameter(Position = 0, ValueFromPipeline = $true)]
    [string]$Auftrag
)

$ErrorActionPreference = 'Stop'

function Get-EnvironmentValue {
    param(
        [string]$Name,
        [string]$Default
    )

    $value = [Environment]::GetEnvironmentVariable($Name)
    if ([string]::IsNullOrEmpty($value)) {
        return $Default
    }
    return $value
}

if ($PSBoundParameters.ContainsKey('Auftrag')) {
    $eingabe = $Auftrag
} else {
    # Ein Here-String in einer PowerShell-Pipeline kommt am Standardinput an.
    $eingabe = [Console]::In.ReadToEnd()
}

$benutzerprofil = [Environment]::GetFolderPath('UserProfile')
$logVerzeichnis = Join-Path $benutzerprofil '.codex-tandem\logs'
New-Item -ItemType Directory -Path $logVerzeichnis -Force | Out-Null
$log = Join-Path $logVerzeichnis ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + $PID + '.log')

$antwortDatei = [IO.Path]::GetTempFileName()

try {
    $sandbox = Get-EnvironmentValue -Name 'CODEX_SANDBOX' -Default 'workspace-write'
    $argumente = @('exec', '-s', $sandbox, '--skip-git-repo-check', '-o', $antwortDatei)

    if (-not [string]::IsNullOrEmpty($env:CODEX_MODEL)) {
        $argumente += @('-m', $env:CODEX_MODEL)
    }

    if (-not [string]::IsNullOrEmpty($env:CODEX_IMAGES)) {
        foreach ($bild in ($env:CODEX_IMAGES -split '\s+' | Where-Object { $_ })) {
            if (-not (Test-Path -LiteralPath $bild -PathType Leaf)) {
                [Console]::Error.WriteLine("codex-do: Referenzbild fehlt: $bild")
                exit 2
            }
            $argumente += @('-i', $bild)
        }
    }

    $argumente += '-'

    # Es wird weder ein Schlüssel noch eine Umgebungsvariable protokolliert,
    # sondern ausschließlich die Ausgabe von codex selbst.
    $eingabe | & codex @argumente 1> $log 2>&1
    $status = $LASTEXITCODE
    if ($null -eq $status) {
        $status = 1
    }

    $antwort = ''
    if ((Test-Path -LiteralPath $antwortDatei) -and ((Get-Item -LiteralPath $antwortDatei).Length -gt 0)) {
        $antwort = [IO.File]::ReadAllText($antwortDatei)
    }

    if (-not [string]::IsNullOrEmpty($antwort)) {
        $zeilen = $antwort -split "`r?`n" | ForEach-Object {
            if ($_.Length -gt 300) { $_.Substring(0, 300) } else { $_ }
        }
        $tailText = Get-EnvironmentValue -Name 'CODEX_TAIL' -Default '25'
        $tail = 25
        [void][int]::TryParse($tailText, [ref]$tail)
        if ($tail -lt 0) { $tail = 0 }
        $zeilen | Select-Object -Last $tail | ForEach-Object { [Console]::Out.WriteLine($_) }
        [Console]::Out.WriteLine("--- codex-do: exit $status · $log")
    } else {
        [Console]::Out.WriteLine("--- codex-do: keine Antwort, exit $status. Letzte Zeilen:")
        Get-Content -LiteralPath $log | Where-Object {
            $_.Length -lt 400 -and -not [string]::IsNullOrWhiteSpace($_)
        } | Select-Object -Last 15 | ForEach-Object {
            if ($_.Length -gt 300) { [Console]::Out.WriteLine($_.Substring(0, 300)) }
            else { [Console]::Out.WriteLine($_) }
        }
        [Console]::Out.WriteLine("--- vollstaendiges Protokoll: $log")
    }

    exit $status
} finally {
    if (Test-Path -LiteralPath $antwortDatei) {
        Remove-Item -LiteralPath $antwortDatei -Force
    }
}
