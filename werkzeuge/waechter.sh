#!/bin/bash
# waechter.sh: schaut ueber die Laufanzeige(n) und die launchd-Jobs und
# meldet per Mac-Mitteilung, wenn etwas fehlt oder rot ist. Sonst meldet er
# sich nicht: Stille heisst "alles in Ordnung", nicht "weiss ich nicht".
#
# Aufruf: waechter.sh          normaler Lauf
#         waechter.sh --probe  loest eine Probemeldung aus, zum Testen
#
# Einstellungen liegen in betrieb/waechter.conf (eine Zeile je Eintrag):
#   anzeige <pfad>              weitere Laufanzeige mitlesen (z.B. die deiner
#                                Werkstatt-Projekte), zusaetzlich zur eigenen
#   takt <name> <stunden>       Job <name> muss mindestens alle <stunden>
#                                Stunden eine OK-Zeile in einer Laufanzeige
#                                hinterlassen haben, sonst gilt er als verpasst
#   praefix <text>              launchd-Jobs, deren Label mit <text> beginnt,
#                                werden per launchctl list auf ihren letzten
#                                Exitcode geprueft
#
# Jede Zeile in waechter.conf wird geprueft: eine falsche Feldanzahl, eine
# nicht-numerische Stundenzahl oder eine unbekannte Direktive wird selbst
# zu einem Befund statt das Skript abzubrechen (set -u wuerde das sonst
# stillschweigend tun).
#
# Zeitstempel in der Laufanzeige stehen immer im Format "JJJJ-MM-TT SS:MM"
# (so schreibt lauf.sh sie). Laesst sich ein Zeitstempel nicht so lesen,
# wird das selbst zu einem Befund statt den Takt stillschweigend zu
# uebergehen.
#
# MR_TEST=1 schreibt die Mitteilung nur ins Protokoll statt sie wirklich
# auszuloesen: so testest du den Waechter, ohne den Bildschirm zu bemuehen.

set -uo pipefail

HIER="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EIGENE_ANZEIGE="$HIER/betrieb/laufanzeige.md"
CONF="$HIER/betrieb/waechter.conf"
BEFUND="$HIER/betrieb/waechter.md"
LOG_DIR="$HIER/betrieb/logs"
mkdir -p "$HIER/betrieb" "$LOG_DIR"
touch "$EIGENE_ANZEIGE"

ANZEIGEN=("$EIGENE_ANZEIGE")
TAKTE=()
PRAEFIXE=()
BEFUNDE=()

if [ -f "$CONF" ]; then
  ZEILENNR=0
  while IFS= read -r zeile || [ -n "$zeile" ]; do
    ZEILENNR=$((ZEILENNR + 1))
    zeile="${zeile%%#*}"
    [ -z "${zeile// /}" ] && continue
    set -- $zeile
    case "$1" in
      anzeige)
        if [ "$#" -ne 2 ]; then
          BEFUNDE+=("waechter.conf Zeile $ZEILENNR: 'anzeige <pfad>' braucht genau ein Feld")
        elif [ ! -f "$2" ]; then
          BEFUNDE+=("waechter.conf Zeile $ZEILENNR: anzeige-Pfad '$2' existiert nicht")
        else
          ANZEIGEN+=("$2")
        fi
        ;;
      takt)
        if [ "$#" -ne 3 ] || ! [[ "$3" =~ ^[0-9]+$ ]]; then
          BEFUNDE+=("waechter.conf Zeile $ZEILENNR: 'takt <name> <stunden>' braucht einen Namen und eine ganze Stundenzahl")
        else
          TAKTE+=("$2 $3")
        fi
        ;;
      praefix)
        if [ "$#" -ne 2 ]; then
          BEFUNDE+=("waechter.conf Zeile $ZEILENNR: 'praefix <text>' braucht genau ein Feld")
        else
          PRAEFIXE+=("$2")
        fi
        ;;
      *)
        BEFUNDE+=("waechter.conf Zeile $ZEILENNR: unbekannte Direktive '$1'")
        ;;
    esac
  done < "$CONF"
fi

GESTERN="$(date -v-1d '+%Y-%m-%d' 2>/dev/null || date -d 'yesterday' '+%Y-%m-%d')"
HEUTE="$(date '+%Y-%m-%d')"
JETZT="$(date '+%Y-%m-%d %H:%M')"

# 1. FEHLER-Zeilen seit gestern in allen bekannten Laufanzeigen.
for datei in "${ANZEIGEN[@]}"; do
  [ -f "$datei" ] || continue
  while IFS= read -r zeile; do
    case "$zeile" in
      "$HEUTE"*|"$GESTERN"*) ;;
      *) continue ;;
    esac
    case "$zeile" in
      *"| FEHLER |"*) BEFUNDE+=("$(basename "$datei"): $zeile") ;;
    esac
  done < "$datei"
done

# 2. Jobs, die laenger als erwartet nicht gelaufen sind (Takte aus waechter.conf).
if [ "${#TAKTE[@]}" -gt 0 ]; then
  JETZT_SEK=$(date +%s)
  for takt in "${TAKTE[@]}"; do
    set -- $takt
    job="$1"; stunden="$2"
    letzter=""
    for datei in "${ANZEIGEN[@]}"; do
      [ -f "$datei" ] || continue
      treffer="$(grep -F "| $job |" "$datei" | tail -1 || true)"
      [ -n "$treffer" ] && letzter="$treffer"
    done
    if [ -z "$letzter" ]; then
      BEFUNDE+=("$job: noch nie gelaufen laut Laufanzeige")
      continue
    fi
    zeit="$(echo "$letzter" | cut -d'|' -f1 | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
    letzter_sek="$(date -j -f '%Y-%m-%d %H:%M' "$zeit" +%s 2>/dev/null || true)"
    if [ -z "$letzter_sek" ]; then
      BEFUNDE+=("$job: Zeitstempel '$zeit' nicht lesbar (erwartet JJJJ-MM-TT SS:MM)")
      continue
    fi
    diff_h=$(( (JETZT_SEK - letzter_sek) / 3600 ))
    if [ "$diff_h" -gt "$stunden" ]; then
      BEFUNDE+=("$job: letzter Lauf vor ${diff_h}h, erwartet spaetestens alle ${stunden}h")
    fi
  done
fi

# 3. launchd-Jobs mit Praefix: letzter Exitcode ungleich 0.
if [ "${#PRAEFIXE[@]}" -gt 0 ] && command -v launchctl >/dev/null; then
  for praefix in "${PRAEFIXE[@]}"; do
    while IFS=$'\t' read -r pid status label; do
      case "$label" in
        "$praefix"*) ;;
        *) continue ;;
      esac
      [ "$status" = "-" ] && continue
      if [ "$status" != "0" ]; then
        BEFUNDE+=("launchd $label: letzter Exitcode $status")
      fi
    done < <(launchctl list 2>/dev/null | tail -n +2)
  done
fi

# Ausgabe: Befund immer schreiben, Mitteilung nur bei Treffern (oder --probe).
{
  echo "# Wächter-Befund"
  echo "Stand: $JETZT"
  echo
  if [ "${#BEFUNDE[@]}" -eq 0 ]; then
    echo "Nichts auffaellig."
  else
    for b in "${BEFUNDE[@]}"; do echo "- $b"; done
  fi
} > "$BEFUND"

melden() {
  local titel="$1" text="$2"
  local mitteilungslog="$LOG_DIR/waechter-mitteilungen.log"
  if [ "${MR_TEST:-0}" = "1" ]; then
    echo "$JETZT MITTEILUNG (Test, nicht ausgeloest): $titel: $text" >> "$mitteilungslog"
    return 0
  fi
  if ! /usr/bin/osascript \
      -e 'on run argv' \
      -e 'display notification (item 1 of argv) with title (item 2 of argv)' \
      -e 'end run' \
      "$text" "$titel" >/dev/null 2>>"$mitteilungslog"; then
    echo "$JETZT MITTEILUNG FEHLGESCHLAGEN: $titel: $text" >> "$mitteilungslog"
  fi
}

if [ "${1:-}" = "--probe" ]; then
  melden "Wächter (Probe)" "Das ist eine Probemeldung von waechter.sh --probe."
  echo "Probemeldung ausgeloest."
  exit 0
fi

if [ "${#BEFUNDE[@]}" -gt 0 ]; then
  melden "Wächter meldet FEHLER" "${BEFUNDE[0]} (und $(( ${#BEFUNDE[@]} - 1 )) weitere, siehe betrieb/waechter.md)"
fi

exit 0
