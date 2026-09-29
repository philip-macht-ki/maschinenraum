#!/bin/bash
# openrouter-probe.sh: ein einzelner Aufruf an ein OpenRouter-Modell, zeigt
# Antwort und tatsaechliche Kosten des Aufrufs in USD - so rechnet
# OpenRouter selbst ab, unabhaengig von deiner eigenen Waehrung. Fuer den
# ersten Test nach der Einrichtung, nicht fuer den Dauerbetrieb.
#
# Aufruf: openrouter-probe.sh [modell] ["frage"]
#   Ohne Angabe: ein guenstiges Modell, deutsche Beispielfrage.
#
# Braucht den Schluessel im Schluesselbund unter dem Dienstnamen "openrouter"
# (siehe schluessel.sh). Eine Kostenobergrenze setzt dieses Skript NICHT -
# die legst du als "Credit limit" direkt am OpenRouter-Schluessel selbst
# fest (openrouter.ai/settings/keys). Es gibt hier keine eigene, zusaetzliche
# Obergrenze zum Verwechseln.
#
# Die Ziel-URL laesst sich ueber OPENROUTER_URL ueberschreiben, z.B. fuer
# einen Test gegen eine absichtlich nicht erreichbare Adresse.
#
# Der Schluessel wird nie als Kommandozeilenargument an curl uebergeben -
# das waere fuer jeden lokalen Prozess ueber `ps` sichtbar. Stattdessen
# steht er kurz in einer nur fuer dich lesbaren (chmod 600) temporaeren
# curl-Konfigurationsdatei, die am Ende garantiert geloescht wird (auch bei
# Abbruch, per trap).

set -uo pipefail

HIER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELL="${1:-qwen/qwen3-14b}"
FRAGE="${2:-Nenne in einem Satz, wofuer man einen Zeitplan auf einem Mac braucht.}"
URL="${OPENROUTER_URL:-https://openrouter.ai/api/v1/chat/completions}"

SCHLUESSEL="$("$HIER/schluessel.sh" openrouter)" || exit 1

CONF_DATEI="$(mktemp)"
chmod 600 "$CONF_DATEI"
trap 'rm -f "$CONF_DATEI"' EXIT

{
  printf 'header = "Authorization: Bearer %s"\n' "$SCHLUESSEL"
  printf 'header = "Content-Type: application/json"\n'
} > "$CONF_DATEI"

ANTWORT="$(curl -s --config "$CONF_DATEI" "$URL" \
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
