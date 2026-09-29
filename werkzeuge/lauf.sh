#!/bin/bash
# lauf.sh: startet einen Befehl mit vollem PATH, schreibt sein Protokoll nach
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
# <name> wird zum Logdateinamen und zur Bezeichnung in der Laufanzeige und
# darf nur aus Buchstaben, Ziffern, Punkt, Unterstrich und Bindestrich
# bestehen ([A-Za-z0-9._-]+) - sonst koennte ein Name mit z.B. "../" Logs
# ausserhalb von betrieb/logs anlegen oder ueberschreiben.
#
# Optional: die Umgebungsvariable ARBEITSORDNER (voller Pfad) wechselt vor
# dem Start des Befehls dorthin. Unter launchd setzt idealerweise schon die
# plist-Vorlage WorkingDirectory - diese Variable ist fuer Aufrufe ausserhalb
# von launchd, z.B. zum Testen von Hand.

set -uo pipefail

if [ -z "${1:-}" ] || [ "${2:-}" != "--" ] || [ "$#" -lt 3 ]; then
  echo "Aufruf: lauf.sh <name> -- <befehl…>" >&2
  exit 2
fi

NAME="$1"
shift 2

case "$NAME" in
  *[!A-Za-z0-9._-]*)
    echo "lauf.sh: ungueltiger Name '$NAME', erlaubt ist nur [A-Za-z0-9._-]+" >&2
    exit 2
    ;;
esac

if [ -n "${ARBEITSORDNER:-}" ]; then
  cd "$ARBEITSORDNER" || {
    echo "lauf.sh: ARBEITSORDNER '$ARBEITSORDNER' nicht erreichbar" >&2
    exit 2
  }
fi

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
