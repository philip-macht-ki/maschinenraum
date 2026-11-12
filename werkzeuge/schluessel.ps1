<# Liest einen DPAPI-geschützten Schlüssel aus %USERPROFILE%\.claude\schluessel.<dienst>.xml. #>
[CmdletBinding()]
param([Parameter(Position = 0)] [string]$Dienst)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($Dienst)) {
    [Console]::Error.WriteLine('Aufruf: schluessel.ps1 <dienst>')
    exit 2
}
if ($Dienst -notmatch '^[A-Za-z0-9._-]+$') {
    [Console]::Error.WriteLine("schluessel.ps1: ungültiger Dienst '$Dienst'")
    exit 2
}

$pfad = Join-Path $env:USERPROFILE ".claude\schluessel.$Dienst.xml"
if (-not (Test-Path $pfad -PathType Leaf)) {
    [Console]::Error.WriteLine("schluessel.ps1: kein DPAPI-Eintrag '$Dienst'. Einmalig interaktiv anlegen mit:")
    [Console]::Error.WriteLine("  Read-Host -AsSecureString | ConvertFrom-SecureString | Set-Content '$pfad'")
    exit 1
}
try {
    $secure = Get-Content -Raw -Path $pfad | ConvertTo-SecureString
    $zeiger = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try {
        [Runtime.InteropServices.Marshal]::PtrToStringBSTR($zeiger)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($zeiger)
    }
}
catch {
    [Console]::Error.WriteLine("schluessel.ps1: Eintrag '$Dienst' kann nicht gelesen werden: $($_.Exception.Message)")
    exit 1
}
