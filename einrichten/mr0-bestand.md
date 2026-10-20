# Einrichten lassen: dein Bestand

**Wofür:** Bevor irgendetwas Neues dazukommt, schreibt Claude auf, was bei
dir schon eingerichtet ist, holt den Werkzeugkasten nach `~/maschinenraum` und
prüft mit der Ampel, ob die Grundausstattung da ist.

**So benutzt du diese Datei:** Öffne Claude in einem beliebigen Ordner und
gib ihm den Text unterhalb der Linie. Hast du zwei Macs, öffne Claude auf dem
Rechner, der dauerhaft läuft, nicht auf dem Laptop.

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
   ROT enthalten, sonst kläre erst, woran es liegt. Ist es die Zeile Time
   Machine, sag mir das. Ein Backup richte ich mit dem Kurs Der Dauerläufer,
   Lektion D4-2 ein.
2. Zeig mir den Inhalt von `~/maschinenraum/betrieb/bestand.md`.
3. Zeig mir `git -C ~/maschinenraum log -1 --oneline`.

## Schritte

1. Zeig mir den Namen dieses Rechners mit `hostname -s` und frag mich, ob
   ich einen zweiten Mac habe, der dauerhaft läuft. Habe ich einen und du
   läufst gerade auf dem Laptop, hör hier auf und sag mir, dass ich die
   Sitzung auf dem Dauerrechner starten soll. Der Werkzeugkasten gehört nur
   dorthin.

2. Prüfe, ob `~/maschinenraum` existiert und ein Git-Ordner ist. Wenn ja,
   sag mir das und mach mit Schritt 4 weiter, ohne etwas zu klonen.

3. Existiert er nicht: frag mich, ob du GitHub einmalig mit dieser
   Kommandozeile verbinden darfst (falls das noch nicht gemacht wurde), und
   danach `git clone https://github.com/philip-macht-ki/maschinenraum
   ~/maschinenraum` ausführen.

4. Führe `bash ~/maschinenraum/pruefen.sh` aus und zeig mir die Ausgabe
   wörtlich.

5. Schau nach, was bei mir schon eingerichtet ist:
   - Dateien in `~/.claude/agents/`
   - Skills, die zu meinem Vorhaben passen könnten (kurz, keine Liste aller
     Skills)
   - geplante Aufgaben an allen fünf Stellen, an denen auf einem Mac etwas
     eingeplant sein kann:
     1. geplante Aufgaben in Claude Code, in `~/.claude/scheduled-tasks/`
     2. Cowork-Aufgaben, in `~/Documents/Claude/Scheduled/`
     3. Routinen in meinem Claude-Konto. Die siehst du nicht als Datei, frag
        mich, welche ich in der App sehe und auf welchem Rechner sie laufen
     4. eigene launchd-Jobs in `~/Library/LaunchAgents/` und mit
        `launchctl list`, soweit an meinem Benutzernamen erkennbar
     5. cron, mit `crontab -l`
   - ob unter diesem oder einem anderen Projektordner schon eine
     `graphify-out/`-Karte liegt

6. Frag mich zwei Dinge und trag die Antwort in die Liste ein:
   - willst du Codex einrichten (ja/nein)?
   - willst du ein lokales Modell (Ollama) einrichten (ja/nein)?

7. Schreib das Ergebnis aus Schritt 1, 5 und 6 als Liste nach
   `~/maschinenraum/betrieb/bestand.md`, mit Datum und dem Namen dieses
   Rechners in der ersten Zeile. Mindestens vier Zeilen. Hab ich einen
   zweiten Mac, schreib dazu, dass dort an denselben fünf Stellen nichts
   takten darf, was hier schon läuft.

8. Führe die Abnahme aus.

## Verbotsliste

- Nichts an `~/.claude/`, einer CLAUDE.md, `~/Library/LaunchAgents/` oder
  `~/.local/bin/` ändern. Diese Datei liest nur und legt `~/maschinenraum`
  an, nichts sonst.
- Keine Konten anlegen außer nach ausdrücklicher Erlaubnis für GitHub.

## Was du mich fragen musst

- ob ich einen zweiten Mac habe, der dauerhaft läuft
- welche Routinen ich in der App sehe
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
