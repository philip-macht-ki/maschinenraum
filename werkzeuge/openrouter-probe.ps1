<# Ein einzelner OpenRouter-Test: Antwort und tatsächliche Kosten in USD. #>
[CmdletBinding()]
param(
    [string]$Modell = 'qwen/qwen3-14b',
    [string]$Frage = 'Nenne in einem Satz, wofür man einen Zeitplan unter Windows braucht.'
)

$ErrorActionPreference = 'Stop'
$url = 'https://openrouter.ai/api/v1/chat/completions'
if ($env:OPENROUTER_URL) { $url = $env:OPENROUTER_URL }

# Der DPAPI-Schlüssel wird nur an den HTTP-Header übergeben, nie protokolliert.
try {
    $schluessel = & (Join-Path $PSScriptRoot 'schluessel.ps1') 'openrouter'
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    $inhalt = @{
        model = $Modell
        max_tokens = 300
        messages = @(@{ role = 'user'; content = $Frage })
    } | ConvertTo-Json -Depth 5
    $antwort = Invoke-RestMethod -UseBasicParsing -Uri $url -Method Post -Headers @{
        Authorization = "Bearer $schluessel"
        'Content-Type' = 'application/json'
    } -Body $inhalt
}
catch {
    [Console]::Error.WriteLine("openrouter-probe: $($_.Exception.Message)")
    exit 1
}
if ($antwort.error) {
    [Console]::Error.WriteLine("Fehler: $($antwort.error.message)")
    exit 1
}
Write-Output '--- Antwort ---'
Write-Output $antwort.choices[0].message.content.Trim()
Write-Output '--- Verbrauch ---'
Write-Output "Eingabe-Tokens: $($antwort.usage.prompt_tokens)"
Write-Output "Ausgabe-Tokens: $($antwort.usage.completion_tokens)"
if ($null -ne $antwort.usage.cost) {
    Write-Output ('Kosten dieses Aufrufs: {0:F5} USD' -f $antwort.usage.cost)
}
