#!/bin/bash
# schluessel.sh: liest einen Schluessel aus dem Schluesselbund und gibt ihn
# NUR an das aufrufende Programm weiter, nie in den Chat und nie ins Protokoll.
#
# Den Schluessel selbst legst du einmalig so ab (tippt der Mensch, nicht
# Claude, denn der Befehl fragt interaktiv nach dem Wert):
#
#   security add-generic-password -s <dienst> -a "$USER" -w
#
# Aufruf hier:
#   schluessel.sh <dienst>
#
# Beispiel:
#   export OPENROUTER_API_KEY="$(werkzeuge/schluessel.sh openrouter)"
#
# Gibt bei Erfolg NUR den Wert auf stdout aus (keine weitere Zeile), bei
# Fehlschlag eine Meldung auf stderr und Exitcode 1.

set -uo pipefail

if [ -z "${1:-}" ]; then
  echo "Aufruf: schluessel.sh <dienst>" >&2
  exit 2
fi

DIENST="$1"
WERT="$(security find-generic-password -s "$DIENST" -a "$USER" -w 2>/dev/null)"

if [ -z "$WERT" ]; then
  echo "schluessel.sh: kein Eintrag '$DIENST' im Schluesselbund fuer $USER. Anlegen mit:" >&2
  echo "  security add-generic-password -s $DIENST -a \"\$USER\" -w" >&2
  exit 1
fi

printf '%s' "$WERT"
