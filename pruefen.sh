#!/bin/bash
# pruefen.sh: Ampel ueber den Stand deines Werkzeugkastens. Ein Blick, keine
# Handlung. GRUEN = passt, GELB = fehlt etwas Freiwilliges oder erst spaeter
# Gebrauchtes, ROT = fehlt etwas, das Teil 1 jetzt braucht.
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

echo "Claude-Profi-Setup, Stand $(date '+%d.%m.%Y %H:%M')"
echo

# Der Rechner. Fuer Teil 1 und 2 ist jeder Mac recht. Zeitplaene aus Teil 3
# laufen nur, solange der Mac an, wach und angemeldet ist; das zeigt die
# Energie-Zeile. Nichts davon ist rot, es ist ein Hinweis.
RECHNER="$(hostname -s)"
ANZEIGENAME="$(scutil --get ComputerName 2>/dev/null || echo "$RECHNER")"
zeile "INFO " "Rechner: $ANZEIGENAME (hostname -s: $RECHNER)"

PM="$(pmset -g 2>/dev/null)"
SCHLAF="$(printf '%s\n' "$PM" | awk '$1 == "sleep" { print $2; exit }')"
NEUSTART="$(printf '%s\n' "$PM" | awk '$1 == "autorestart" { print $2; exit }')"
if [ "$SCHLAF" = 0 ] && [ "$NEUSTART" = 1 ]; then
  zeile "GRUEN" "Energie: schläft nie und startet nach einem Stromausfall von allein"
elif [ "$SCHLAF" = 0 ]; then
  zeile "GELB " "Energie: schläft nie, startet nach einem Stromausfall aber nicht von allein (erst für Zeitpläne in Teil 3 wichtig)"
  GELB=1
else
  zeile "GELB " "Energie: schläft nach ${SCHLAF:-?} Minuten. Für Teil 1 und 2 egal; Zeitpläne in Teil 3 laufen nur, solange der Mac wach ist"
  GELB=1
fi

if tmutil destinationinfo 2>/dev/null | grep -q "^Name"; then
  zeile "GRUEN" "Backup: Time Machine hat ein Ziel"
else
  zeile "GELB " "Backup: Time Machine hat kein Ziel (freiwillig, aber empfohlen: Systemeinstellungen, Allgemein, Time Machine)"
  GELB=1
fi

# Nichts davon muss jemand selbst installieren. Der Werkzeugkasten kommt ohne
# Git aus (werkzeuge/aktualisieren.sh), claude legt werkzeuge/claude-starter.sh
# fuer Teil 3 an, uv und graphify kommen in Teil 4 in den Benutzerordner.
pruefe_befehl git 0
pruefe_befehl uv 0
pruefe_befehl graphify 0
if command -v claude >/dev/null 2>&1; then
  zeile "GRUEN" "claude gefunden ($(command -v claude))"
else
  zeile "GELB " "claude fehlt im Suchpfad (erst für Zeitpläne in Teil 3 nötig, dann legt dein Claude einen Starter an)"
  GELB=1
fi
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
  zeile "GELB " "~/.claude/agents fehlt noch (die Helfer kommen in Teil 1, der Rechercheur aus dem Basis-Setup)"
  GELB=1
fi

if command -v codex-do >/dev/null 2>&1 || [ -x "$HOME/.local/bin/codex-do" ]; then
  zeile "GRUEN" "codex-do gefunden"
else
  zeile "GELB " "codex-do fehlt (freiwillig, kommt in Teil 2)"
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
