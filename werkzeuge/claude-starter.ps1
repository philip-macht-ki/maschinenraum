<# Prueft die Claude-CLI unter Windows. Die offizielle Installation erfolgt mit winget oder dem Claude-Installer. #>
[CmdletBinding()] param()
if (Get-Command claude -ErrorAction SilentlyContinue) { Write-Output "claude ist schon da: $((Get-Command claude).Source)"; exit 0 }
Write-Error 'claude fehlt. Installiere Claude Code unter Windows mit dem offiziellen Installer oder winget und starte PowerShell danach neu.'; exit 127
