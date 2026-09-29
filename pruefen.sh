#!/bin/bash
# pruefen.sh: Ampel ueber den Stand deines Maschinenraums. Ein Blick, keine
# Handlung. GRUEN = passt, GELB = fehlt etwas Freiwilliges, ROT = fehlt etwas
# Noetiges.
#
# Aufruf: pruefen.sh

set -uo pipefail

HIER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROT=0
GELB=0

zeile() {
  # zeile <ampel> <text>
  printf '%s  %s\n' "$1" "$2"
}

pruefe_befehl() {
  # pruefe_befehl <name> <pflicht:0|1>
  local name="$1" pflicht="$2"
  if command -v "$name" >/dev/null 2>&1; then
    zeile "GRUEN" "$name gefunden ($(command -v "$name"))"
  elif [ "$pflicht" = 1 ]; then
    zeile "ROT  " "$name fehlt"
    ROT=1
  else
    zeile "GELB " "$name fehlt (freiwillig)"
    GELB=1
  fi
}

echo "Maschinenraum, Stand $(date '+%d.%m.%Y %H:%M')"
echo

pruefe_befehl git 1
pruefe_befehl brew 0
pruefe_befehl uv 0
pruefe_befehl graphify 0
pruefe_befehl claude 1
pruefe_befehl codex 0
pruefe_befehl ollama 0

if [ -w "$HIER/betrieb" ]; then
  zeile "GRUEN" "Ordner betrieb/ ist beschreibbar"
else
  zeile "ROT  " "Ordner betrieb/ ist nicht beschreibbar"
  ROT=1
fi

if [ -d "$HOME/.claude/agents" ]; then
  ANZAHL="$(find "$HOME/.claude/agents" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')"
  if [ "$ANZAHL" -gt 0 ]; then
    zeile "GRUEN" "$ANZAHL Helfer in ~/.claude/agents"
  else
    zeile "GELB " "~/.claude/agents ist da, aber leer"
    GELB=1
  fi
else
  zeile "GELB " "~/.claude/agents fehlt noch (Helfer nicht eingerichtet)"
  GELB=1
fi

if command -v codex-do >/dev/null 2>&1 || [ -x "$HOME/.local/bin/codex-do" ]; then
  zeile "GRUEN" "codex-do gefunden"
else
  zeile "GELB " "codex-do fehlt (freiwillig, sehr empfohlen)"
  GELB=1
fi

if command -v ollama >/dev/null 2>&1; then
  if curl -s -m 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    zeile "GRUEN" "ollama läuft"
  else
    zeile "GELB " "ollama installiert, aber der Dienst antwortet nicht (freiwillig)"
    GELB=1
  fi
fi

echo
if [ "$ROT" = 1 ]; then
  echo "Gesamturteil: ROT, etwas Nötiges fehlt, siehe oben."
  exit 1
elif [ "$GELB" = 1 ]; then
  echo "Gesamturteil: GELB, läuft, freiwillige Teile fehlen noch."
  exit 0
else
  echo "Gesamturteil: GRUEN."
  exit 0
fi
