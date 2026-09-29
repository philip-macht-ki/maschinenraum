#!/bin/bash
# sitzungsstart.sh: Hook fuer SessionStart. Gibt die letzten FEHLER-Zeilen
# der Laufanzeige(n) aus, sonst nichts. So beginnt jede neue Sitzung mit dem
# Stand deines Betriebs, ohne dass du danach fragen musst.
#
# Wird ueber ~/.claude/settings.json unter hooks.SessionStart eingetragen
# (siehe einrichten/mr4-hooks.md). Bekommt von Claude Code ein JSON auf
# stdin, das hier nicht gebraucht wird.

set -uo pipefail

HOECHSTENS=10
GEFUNDEN=0

pruefe_datei() {
  local datei="$1"
  [ -f "$datei" ] || return
  local treffer
  treffer="$(grep -F '| FEHLER |' "$datei" 2>/dev/null | tail -"$HOECHSTENS")"
  [ -z "$treffer" ] && return
  GEFUNDEN=1
  echo "FEHLER in $datei:"
  echo "$treffer"
}

pruefe_datei "$HOME/maschinenraum/betrieb/laufanzeige.md"

# Weitere Laufanzeigen (z.B. aus einem Werkstatt-Projektordner) traegt
# mr4-hooks.md hier als weitere pruefe_datei-Zeile ein, wenn du einen
# eigenen Pfad angibst.

if [ "$GEFUNDEN" = 0 ]; then
  exit 0
fi

exit 0
