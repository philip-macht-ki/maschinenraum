#!/bin/bash
# codex-aktualisieren.sh: haelt die Codex-Kommandozeile aktuell, die mr2-codex
# ohne Homebrew und npm nach ~/.local/bin/codex gelegt hat. Laedt nur, wenn es
# eine neuere Version gibt. Eine Codex-Installation an anderer Stelle (etwa
# ueber Homebrew oder npm) fasst es nicht an, sondern sagt, womit sie
# aktualisiert wird. Druckt am Ende eine Zeile fuer die Laufanzeige.
#
# Aufruf: bash ~/maschinenraum/werkzeuge/codex-aktualisieren.sh

set -euo pipefail

ZIEL="$HOME/.local/bin/codex"
ARCHIV="codex-aarch64-apple-darwin.tar.gz"
API="https://api.github.com/repos/openai/codex/releases/latest"

if [ ! -x "$ZIEL" ]; then
  if command -v codex >/dev/null 2>&1; then
    echo "OK codex liegt unter $(command -v codex), nicht in ~/.local/bin. Aktualisieren mit dem Werkzeug, das es installiert hat."
  else
    echo "OK codex ist nicht eingerichtet, nichts zu tun."
  fi
  exit 0
fi

JETZT="$("$ZIEL" --version 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
ANTWORT="$(curl -fsSL -m 15 "$API")" || { echo "FEHLER codex: neueste Version nicht abrufbar"; exit 1; }
NEUESTE="$(printf '%s' "$ANTWORT" | grep -Eo '"tag_name": *"[^"]*"' | head -1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' || true)"
URL="$(printf '%s' "$ANTWORT" | grep -Eo "https://[^\"]*/$ARCHIV" | head -1 || true)"

if [ -z "$NEUESTE" ] || [ -z "$URL" ]; then
  echo "FEHLER codex: Archiv $ARCHIV in der neuesten Veröffentlichung (noch) nicht gefunden, beim nächsten Lauf erneut"
  exit 1
fi
if [ "$JETZT" = "$NEUESTE" ]; then
  echo "OK codex $JETZT ist aktuell"
  exit 0
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
curl -fsSL "$URL" | tar -xz -C "$TMP"
NEU="$(find "$TMP" -type f -name 'codex*' ! -name '*.tar.gz' | head -1)"
[ -n "$NEU" ] || { echo "FEHLER codex: im Archiv keine Programmdatei gefunden"; exit 1; }
chmod +x "$NEU"
"$NEU" --version >/dev/null 2>&1 || { echo "FEHLER codex: neue Version startet nicht, alte bleibt"; exit 1; }
cp -p "$ZIEL" "$ZIEL.vorher"
mv "$NEU" "$ZIEL"
echo "OK codex von ${JETZT:-unbekannt} auf $NEUESTE aktualisiert (alte Fassung: $ZIEL.vorher)"
