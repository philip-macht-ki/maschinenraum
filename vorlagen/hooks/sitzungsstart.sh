#!/bin/bash
# sitzungsstart.sh: Hook fuer SessionStart. Zeigt nur die FEHLER-Zeilen der
# Laufanzeige(n), die seit dem LETZTEN Sitzungsstart neu dazugekommen sind -
# nicht jeden alten Fehler wieder und wieder. So beginnt jede neue Sitzung
# mit dem, was seither passiert ist.
#
# Wird ueber ~/.claude/settings.json unter hooks.SessionStart eingetragen
# (siehe einrichten/mr4-hooks.md). Bekommt von Claude Code ein JSON auf
# stdin, das hier nicht gebraucht wird.
#
# Merkt sich je beobachteter Laufanzeige die zuletzt gesehene Zeilenzahl in
# betrieb/.sitzungsstart-gesehen (eine Zeile "<pfad><TAB><zeilenzahl>").
# Neue Zeilen erkennt der Hook rein an der gewachsenen Zeilenzahl seit dem
# letzten Mal - kein Zeitstempel-Parsing noetig, und ein Job, der zwischen
# zwei Sitzungen mehrfach OK meldet, aendert daran nichts.

set -uo pipefail

MERKER="$HOME/maschinenraum/betrieb/.sitzungsstart-gesehen"
mkdir -p "$(dirname "$MERKER")"
touch "$MERKER"

HOECHSTENS=10
GEFUNDEN=0

NEU_MERKER="$(mktemp "${MERKER}.XXXXXX")"
trap 'rm -f "$NEU_MERKER"' EXIT

gesehene_zeilen() {
  # gesehene_zeilen <pfad>  -> zuletzt gemerkte Zeilenzahl, leer wenn unbekannt
  awk -F'\t' -v p="$1" '$1 == p {z = $2} END {print z}' "$MERKER"
}

pruefe_datei() {
  local datei="$1" gesamt vorher neu
  [ -f "$datei" ] || return
  gesamt="$(wc -l < "$datei" | tr -d ' ')"
  vorher="$(gesehene_zeilen "$datei")"
  [ -z "$vorher" ] && vorher=0
  if [ "$gesamt" -gt "$vorher" ]; then
    neu="$(tail -n "+$((vorher + 1))" "$datei" | grep -F '| FEHLER |' | tail -"$HOECHSTENS")"
    if [ -n "$neu" ]; then
      GEFUNDEN=1
      echo "Neue FEHLER in $datei seit der letzten Sitzung:"
      echo "$neu"
    fi
  fi
  printf '%s\t%s\n' "$datei" "$gesamt" >> "$NEU_MERKER"
}

pruefe_datei "$HOME/maschinenraum/betrieb/laufanzeige.md"

# Weitere Laufanzeigen (z.B. aus einem Werkstatt-Projektordner) traegt
# mr4-hooks.md hier als weitere pruefe_datei-Zeile ein, wenn du einen
# eigenen Pfad angibst.

# Dateien aus dem alten Merker, die diesmal nicht erneut geprueft wurden
# (z.B. ein Pfad, der gerade nicht lesbar war), bleiben mit ihrem alten
# Stand erhalten statt zu verschwinden.
if [ -s "$MERKER" ]; then
  awk -F'\t' 'NR==FNR {gesehen[$1]=1; next} !($1 in gesehen)' "$NEU_MERKER" "$MERKER" >> "$NEU_MERKER"
fi

mv "$NEU_MERKER" "$MERKER"
trap - EXIT

if [ "$GEFUNDEN" = 0 ]; then
  exit 0
fi

exit 0
