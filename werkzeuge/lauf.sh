#!/bin/bash
# lauf.sh — startet einen Befehl mit vollem PATH, schreibt sein Protokoll nach
# betrieb/logs/<name>.log und haengt eine Zeile an betrieb/laufanzeige.md an.
#
# Wozu: launchd kennt deinen PATH nicht und dein Terminal-Profil nicht. Ein
# Job, der im Terminal laeuft und nachts nicht, hat fast immer diese Ursache.
# lauf.sh setzt den PATH einmal fest und ist die einzige Stelle, die das tun
# muss - jeder Job ruft nur noch lauf.sh auf.
#
# Aufruf:
#   lauf.sh <name> -- <befehl…>
#
# Beispiel:
#   lauf.sh graphify-karte -- graphify update .
#
# <name> wird zum Logdateinamen und zur Bezeichnung in der Laufanzeige.

set -uo pipefail

if [ "${2:-}" != "--" ] || [ -z "${1:-}" ]; then
  echo "Aufruf: lauf.sh <name> -- <befehl…>" >&2
  exit 2
fi

NAME="$1"
shift 2

export PATH="/opt/homebrew/bin:$HOME/.local/bin:/usr/bin:/bin:${PATH:-}"

HIER="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$HIER/betrieb/logs"
ANZEIGE="$HIER/betrieb/laufanzeige.md"
mkdir -p "$LOG_DIR"
touch "$ANZEIGE"

LOG="$LOG_DIR/$NAME.log"
STAMPEL="$(date '+%Y-%m-%d %H:%M')"

echo "=== $STAMPEL START: $* ===" >> "$LOG"
"$@" >> "$LOG" 2>&1
RC=$?

if [ "$RC" = "0" ]; then
  echo "$STAMPEL | $NAME | OK" >> "$ANZEIGE"
else
  LETZTE_ZEILE="$(tail -1 "$LOG" 2>/dev/null | cut -c1-200)"
  echo "$STAMPEL | $NAME | FEHLER | Exitcode $RC: $LETZTE_ZEILE" >> "$ANZEIGE"
fi

exit "$RC"
