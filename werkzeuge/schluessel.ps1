<# Liest einen DPAPI-geschuetzten Schluessel aus %USERPROFILE%\.claude\schluessel.<dienst>.xml.
   Einmalig interaktiv anlegen: Read-Host -AsSecureString | ConvertFrom-SecureString | Set-Content ... #>
[CmdletBinding()]
param([Parameter(Mandatory, Position=0)][ValidatePattern('^[A-Za-z0-9._-]+$')][string]$Dienst)
$ErrorActionPreference = 'Stop'
$pfad = Join-Path $env:USERPROFILE ".claude\schluessel.$Dienst.xml"
if (-not (Test-Path $pfad)) { [Console]::Error.WriteLine("schluessel.ps1: kein DPAPI-Eintrag '$Dienst'. Einmalig interaktiv anlegen mit:"); [Console]::Error.WriteLine("  Read-Host -AsSecureString | ConvertFrom-SecureString | Set-Content '$pfad'"); exit 1 }
try { $secure = Get-Content -Raw $pfad | ConvertTo-SecureString; $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure); try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) } finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) } } catch { [Console]::Error.WriteLine("schluessel.ps1: Eintrag '$Dienst' kann nicht gelesen werden: $($_.Exception.Message)"); exit 1 }
