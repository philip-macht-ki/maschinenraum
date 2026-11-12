<# Einzelner OpenRouter-Test. Der Schluessel wird nur aus schluessel.ps1 gelesen und nie protokolliert. #>
[CmdletBinding()]
param([string]$Modell = 'qwen/qwen3-14b', [string]$Frage = 'Nenne in einem Satz, wofuer man einen Zeitplan unter Windows braucht.')
$ErrorActionPreference = 'Stop'; $url = if ($env:OPENROUTER_URL) { $env:OPENROUTER_URL } else { 'https://openrouter.ai/api/v1/chat/completions' }
try { $schluessel = & (Join-Path $PSScriptRoot 'schluessel.ps1') openrouter; if ($LASTEXITCODE) { exit $LASTEXITCODE }; $body = @{model=$Modell; max_tokens=300; messages=@(@{role='user';content=$Frage})} | ConvertTo-Json -Depth 5; $antwort = Invoke-RestMethod -Uri $url -Method Post -Headers @{Authorization="Bearer $schluessel"; 'Content-Type'='application/json'} -Body $body } catch { [Console]::Error.WriteLine("openrouter-probe: $($_.Exception.Message)"); exit 1 }
if ($antwort.error) { [Console]::Error.WriteLine("Fehler: $($antwort.error.message)"); exit 1 }
Write-Output '--- Antwort ---'; Write-Output $antwort.choices[0].message.content.Trim(); Write-Output '--- Verbrauch ---'; Write-Output "Eingabe-Tokens: $($antwort.usage.prompt_tokens)"; Write-Output "Ausgabe-Tokens: $($antwort.usage.completion_tokens)"; if ($null -ne $antwort.usage.cost) { Write-Output ('Kosten dieses Aufrufs: {0:N5} USD' -f $antwort.usage.cost) }
