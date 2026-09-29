# Einrichten lassen: dein Bestand

**Wofür:** Bevor irgendetwas Neues dazukommt, schreibt Claude auf, was bei
dir schon eingerichtet ist, holt den Werkzeugkasten nach `~/maschinenraum` und
prüft mit der Ampel, ob die Grundausstattung da ist.

**So benutzt du diese Datei:** Öffne Claude in einem beliebigen Ordner und
gib ihm den Text unterhalb der Linie.

---

```
Richte mir den Werkzeugkasten ein und schreib mir auf, was bei mir schon
läuft.

## Ziel

github.com/philip-macht-ki/maschinenraum liegt nach dieser Einrichtung unter
~/maschinenraum. Ein Blick auf betrieb/bestand.md sagt mir und dir jederzeit,
welche Helfer, Skills, Routinen und Karten ich schon habe, ohne dass wir das
in jeder neuen Sitzung neu zusammensuchen.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir die Ausgabe von `bash ~/maschinenraum/pruefen.sh`. Sie darf kein
   ROT enthalten, sonst kläre erst, woran es liegt.
2. Zeig mir den Inhalt von `~/maschinenraum/betrieb/bestand.md`.
3. Zeig mir `git -C ~/maschinenraum log -1 --oneline`.

## Schritte

1. Prüfe, ob `~/maschinenraum` existiert und ein Git-Ordner ist. Wenn ja,
   sag mir das und mach mit Schritt 3 weiter, ohne etwas zu klonen.

2. Existiert er nicht: frag mich, ob du GitHub einmalig mit dieser
   Kommandozeile verbinden darfst (falls das noch nicht gemacht wurde), und
   danach `git clone https://github.com/philip-macht-ki/maschinenraum
   ~/maschinenraum` ausführen.

3. Führe `bash ~/maschinenraum/pruefen.sh` aus und zeig mir die Ausgabe
   wörtlich.

4. Schau nach, was bei mir schon eingerichtet ist:
   - Dateien in `~/.claude/agents/`
   - Skills, die zu meinem Vorhaben passen könnten (kurz, keine Liste aller
     Skills)
   - geplante Aufgaben (Desktop-Routinen) und eigene launchd-Jobs mit
     `launchctl list`, soweit an meinem Benutzernamen erkennbar
   - ob unter diesem oder einem anderen Projektordner schon eine
     `graphify-out/`-Karte liegt

5. Frag mich zwei Dinge und trag die Antwort in die Liste ein:
   - willst du Codex einrichten (ja/nein)?
   - willst du ein lokales Modell (Ollama) einrichten (ja/nein)?

6. Schreib das Ergebnis aus Schritt 4 und 5 als Liste nach
   `~/maschinenraum/betrieb/bestand.md`, mit Datum. Mindestens vier Zeilen.

7. Führe die Abnahme aus.

## Verbotsliste

- Nichts an `~/.claude/`, einer CLAUDE.md, `~/Library/LaunchAgents/` oder
  `~/.local/bin/` ändern. Diese Datei liest nur und legt `~/maschinenraum`
  an, nichts sonst.
- Keine Konten anlegen außer nach ausdrücklicher Erlaubnis für GitHub.

## Was du mich fragen musst

- ob GitHub verbunden werden darf, falls nötig
- ob ich Codex will
- ob ich ein lokales Modell will

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- Ampel-Ausgabe von pruefen.sh
- Inhalt von betrieb/bestand.md
- meine zwei Entscheidungen (Codex, lokales Modell)
```

---

## Was jetzt anders ist

Du hast eine eigene Kopie des Werkzeugkastens auf deinem Rechner, und eine
Datei, die zeigt, was du schon hast und was noch fehlt. Jede weitere Lektion
baut darauf auf, ohne dass du dich erinnern musst, was du schon eingerichtet
hast.
