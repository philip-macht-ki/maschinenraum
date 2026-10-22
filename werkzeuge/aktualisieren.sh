#!/bin/bash
# aktualisieren.sh: holt die neueste Fassung des Werkzeugkastens. Ohne Git und
# ohne GitHub-Konto: Ist der Ordner ein Git-Ordner, reicht ein git pull. Sonst
# laedt das Skript das oeffentliche Archiv und legt es ueber den Ordner. Deine
# eigenen Dateien in betrieb/ bleiben unberuehrt.
#
# Aufruf: bash ~/maschinenraum/werkzeuge/aktualisieren.sh

set -euo pipefail

HIER="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIV="${MASCHINENRAUM_ARCHIV:-https://github.com/philip-macht-ki/maschinenraum/archive/refs/heads/main.tar.gz}"

if [ -d "$HIER/.git" ] && command -v git >/dev/null 2>&1 && git -C "$HIER" rev-parse >/dev/null 2>&1; then
  git -C "$HIER" pull --ff-only
  exit 0
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
curl -fsSL "$ARCHIV" | tar -xz -C "$TMP" --strip-components 1
rsync -a --exclude 'betrieb/' "$TMP/" "$HIER/"
mkdir -p "$HIER/betrieb"
echo "Werkzeugkasten aktualisiert: $HIER"
