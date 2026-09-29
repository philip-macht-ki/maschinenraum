#!/bin/bash
# openrouter-probe.sh: ein einzelner Aufruf an ein OpenRouter-Modell, zeigt
# Antwort und tatsaechliche Kosten des Aufrufs. Fuer den ersten Test nach der
# Einrichtung, nicht fuer den Dauerbetrieb.
#
# Aufruf: openrouter-probe.sh [modell] ["frage"]
#   Ohne Angabe: ein guenstiges Modell, deutsche Beispielfrage.
#
# Braucht den Schluessel im Schluesselbund unter dem Dienstnamen "openrouter"
# (siehe schluessel.sh) und eine positive Kostenobergrenze in EUR_LIMIT, falls
# du sie strenger als den Standard setzen willst.

set -uo pipefail

HIER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELL="${1:-qwen/qwen3-14b}"
FRAGE="${2:-Nenne in einem Satz, wofuer man einen Zeitplan auf einem Mac braucht.}"

SCHLUESSEL="$("$HIER/schluessel.sh" openrouter)" || exit 1

ANTWORT="$(curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $SCHLUESSEL" \
  -H "Content-Type: application/json" \
  -d "$(python3 -c '
import json, sys
modell, frage = sys.argv[1], sys.argv[2]
print(json.dumps({
    "model": modell,
    "max_tokens": 300,
    "messages": [{"role": "user", "content": frage}],
}))
' "$MODELL" "$FRAGE")")"

if [ -z "$ANTWORT" ]; then
  echo "openrouter-probe: keine Antwort erhalten." >&2
  exit 1
fi

echo "$ANTWORT" | python3 -c '
import json, sys
d = json.load(sys.stdin)
if "error" in d:
    print("Fehler:", d["error"].get("message", d["error"]))
    sys.exit(1)
inhalt = d["choices"][0]["message"]["content"].strip()
verbrauch = d.get("usage", {})
print("--- Antwort ---")
print(inhalt)
print("--- Verbrauch ---")
print(f"Eingabe-Tokens: {verbrauch.get(\"prompt_tokens\", \"?\")}")
print(f"Ausgabe-Tokens: {verbrauch.get(\"completion_tokens\", \"?\")}")
kosten = verbrauch.get("cost")
if kosten is not None:
    print(f"Kosten dieses Aufrufs: {kosten:.5f} USD")
'
