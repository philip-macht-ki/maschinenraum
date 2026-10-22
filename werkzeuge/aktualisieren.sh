#!/bin/bash
# aktualisieren.sh: holt die neueste Fassung des Werkzeugkastens. Ohne Git und
# ohne GitHub-Konto: Ist der Ordner ein Git-Ordner, reicht ein git pull. Sonst
# laedt das Skript das oeffentliche Archiv und legt es ueber den Ordner.
#
# Was es dabei festhaelt und schuetzt:
# - betrieb/stand.txt: Kennung (Commit) des Standes, der jetzt installiert ist
# - betrieb/stand-dateien.txt: Pruefsumme jeder installierten Datei. Daran
#   erkennt das naechste Update, welche Datei du selbst geaendert hast. Die
#   wird vor dem Ueberschreiben als <datei>.vor-update-<datum> gesichert.
# - Ausgabe: alte und neue Kennung und die Liste der geaenderten Dateien.
# Deine eigenen Dateien in betrieb/ fasst es nie an.
#
# Aufruf: bash ~/maschinenraum/werkzeuge/aktualisieren.sh

set -euo pipefail

HIER="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="${MASCHINENRAUM_REPO:-philip-macht-ki/maschinenraum}"
STAND="$HIER/betrieb/stand.txt"
LISTE="$HIER/betrieb/stand-dateien.txt"
HEUTE="$(date +%Y%m%d)"
mkdir -p "$HIER/betrieb"

ALT="unbekannt"
[ -s "$STAND" ] && ALT="$(awk 'NR == 1 { print $1 }' "$STAND")"

if [ -d "$HIER/.git" ] && command -v git >/dev/null 2>&1 && git -C "$HIER" rev-parse >/dev/null 2>&1; then
  ALT="$(git -C "$HIER" rev-parse --short HEAD)"
  # --ff-only bricht ab, statt eigene Aenderungen zu ueberschreiben.
  git -C "$HIER" pull --ff-only
  NEU="$(git -C "$HIER" rev-parse --short HEAD)"
  echo "$NEU $(date '+%d.%m.%Y %H:%M') git" > "$STAND"
  echo "Stand vorher: $ALT"
  echo "Stand jetzt:  $NEU"
  if [ "$ALT" != "$NEU" ]; then
    echo "Geänderte Dateien:"
    git -C "$HIER" diff --name-status "$ALT" "$NEU" | sed 's/^/  /'
  else
    echo "Keine Änderungen."
  fi
  exit 0
fi

# Kennung des neuesten Standes. Ohne Konto abrufbar; schlaegt der Abruf fehl
# (etwa zu viele Abrufe in einer Stunde), laedt das Skript trotzdem "main".
NEU="$(curl -fsSL -m 15 "https://api.github.com/repos/$REPO/commits/main" 2>/dev/null \
  | grep -Eo '"sha": *"[0-9a-f]{40}"' | head -1 | grep -Eo '[0-9a-f]{40}' | cut -c1-7 || true)"
REF="${NEU:-main}"
NEU="${NEU:-unbekannt}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
curl -fsSL "https://github.com/$REPO/archive/$REF.tar.gz" | tar -xz -C "$TMP" --strip-components 1

pruefsumme() { shasum -a 256 "$1" | awk '{print $1}'; }
gespeichert() { [ -s "$LISTE" ] && awk -v d="$1" '$2 == d { print $1; exit }' "$LISTE" || true; }

GEAENDERT=()
GESICHERT=()
while IFS= read -r -d '' datei; do
  rel="${datei#"$TMP"/}"
  case "$rel" in betrieb/*) continue ;; esac
  ziel="$HIER/$rel"
  if [ ! -e "$ziel" ]; then
    GEAENDERT+=("neu       $rel")
    continue
  fi
  jetzt="$(pruefsumme "$ziel")"
  [ "$jetzt" = "$(pruefsumme "$datei")" ] && continue
  GEAENDERT+=("geändert  $rel")
  vorher="$(gespeichert "$rel")"
  # Selbst geaendert heisst: weicht vom zuletzt installierten Stand ab. Gibt es
  # noch keine Liste, wird im Zweifel gesichert.
  if [ -z "$vorher" ] || [ "$vorher" != "$jetzt" ]; then
    cp -p "$ziel" "$ziel.vor-update-$HEUTE"
    GESICHERT+=("$rel.vor-update-$HEUTE")
  fi
done < <(find "$TMP" -type f -print0)

rsync -a --exclude 'betrieb/' "$TMP/" "$HIER/"

# Pruefsummen des jetzt installierten Standes fuer das naechste Update.
( cd "$TMP" && find . -type f ! -path './betrieb/*' -print0 \
  | while IFS= read -r -d '' f; do printf '%s %s\n' "$(pruefsumme "$f")" "${f#./}"; done ) > "$LISTE"
echo "$NEU $(date '+%d.%m.%Y %H:%M') archiv" > "$STAND"

echo "Werkzeugkasten aktualisiert: $HIER"
echo "Stand vorher: $ALT"
echo "Stand jetzt:  $NEU"
if [ "${#GEAENDERT[@]}" -gt 0 ]; then
  echo "Geänderte Dateien:"
  printf '  %s\n' "${GEAENDERT[@]}"
else
  echo "Keine Änderungen."
fi
if [ "${#GESICHERT[@]}" -gt 0 ]; then
  echo "Eigene Änderungen gesichert, bevor sie überschrieben wurden:"
  printf '  %s\n' "${GESICHERT[@]}"
fi
