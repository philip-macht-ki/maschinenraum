<# Prüft die Claude-CLI unter Windows; der macOS-App-Starter hat kein Windows-Gegenstück. #>
[CmdletBinding()]
param()

$claude = Get-Command 'claude' -ErrorAction SilentlyContinue
if ($claude) {
    Write-Output "claude ist schon da: $($claude.Source)"
    exit 0
}

[Console]::Error.WriteLine('claude fehlt. Unter Windows gibt es keinen App-Starter wie unter macOS; installiere Claude Code mit dem offiziellen Installer oder winget und starte PowerShell danach neu.')
exit 127
