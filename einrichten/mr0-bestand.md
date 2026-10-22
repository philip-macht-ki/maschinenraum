# Einrichten lassen: dein Bestand

**Wofür:** Bevor irgendetwas Neues dazukommt, schreibt Claude auf, was bei
dir schon eingerichtet ist, holt den Werkzeugkasten nach `~/maschinenraum` und
prüft mit der Ampel, ob die Grundausstattung da ist.

**So benutzt du diese Datei:** Öffne Claude in einem beliebigen Ordner und
gib ihm den Text unterhalb der Linie. Du tippst keinen Befehl, das macht
dein Claude.

---

```
Richte mir den Werkzeugkasten ein und schreib mir auf, was bei mir schon
läuft.

## Ziel

Der Werkzeugkasten von github.com/philip-macht-ki/maschinenraum liegt nach
dieser Einrichtung unter ~/maschinenraum. Ein Blick auf betrieb/bestand.md
sagt mir und dir jederzeit, welche Helfer, Skills und Routinen ich schon
habe, ohne dass wir das in jeder neuen Sitzung neu zusammensuchen.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir die Ausgabe von `bash ~/maschinenraum/pruefen.sh`. Sie darf kein
   ROT enthalten, sonst kläre erst, woran es liegt. Gelbe Zeilen erklärst du
   mir in einem Satz; sie gehören zu späteren Teilen oder sind freiwillig.
2. Zeig mir den Inhalt von `~/maschinenraum/betrieb/bestand.md`.
3. Zeig mir `ls ~/maschinenraum/einrichten`.

## Schritte

1. Zeig mir den Namen dieses Rechners mit `scutil --get ComputerName`. Frag
   mich, ob ich einen zweiten Mac habe, der dauerhaft läuft. Habe ich einen,
   schreib das in die Liste: Zeitpläne aus Teil 3 gehören später nur auf
   einen der beiden Rechner. Für Teil 1 ist jeder Mac recht.

2. Prüfe, ob `~/maschinenraum` existiert. Wenn ja, sag mir das und führe
   `bash ~/maschinenraum/werkzeuge/aktualisieren.sh` aus, statt neu zu laden.

3. Existiert er nicht: lade das öffentliche Archiv, ohne Git und ohne
   GitHub-Konto:
   mkdir -p ~/maschinenraum && curl -fsSL https://github.com/philip-macht-ki/maschinenraum/archive/refs/heads/main.tar.gz | tar -xz -C ~/maschinenraum --strip-components 1
   Ich tippe dabei nichts. Fragt die Claude-App um Erlaubnis, sag mir in
   einem Satz, was gleich passiert.

4. Führe `bash ~/maschinenraum/pruefen.sh` aus und zeig mir die Ausgabe
   wörtlich.

5. Schau nach, was bei mir schon eingerichtet ist:
   - Dateien in `~/.claude/agents/`, vor allem der Rechercheur aus dem
     Basis-Setup
   - Skills, die zu meiner Arbeit passen könnten (kurz, keine Liste aller
     Skills)
   - geplante Aufgaben an den Stellen, an denen auf einem Mac etwas
     eingeplant sein kann:
     1. geplante Aufgaben in Claude Code, in `~/.claude/scheduled-tasks/`
     2. Cowork-Aufgaben, in `~/Documents/Claude/Scheduled/`
     3. Routinen in meinem Claude-Konto. Die siehst du nicht als Datei, frag
        mich, welche ich in der App sehe
     4. eigene Zeitpläne in `~/Library/LaunchAgents/`, soweit an meinem
        Benutzernamen erkennbar
     5. cron, mit `crontab -l`

6. Schreib das Ergebnis aus Schritt 1 und 5 als Liste nach
   `~/maschinenraum/betrieb/bestand.md`, mit Datum und dem Namen dieses
   Rechners in der ersten Zeile. Mindestens vier Zeilen.

7. Führe die Abnahme aus.

## Verbotsliste

- Nichts an `~/.claude/`, einer CLAUDE.md, `~/Library/LaunchAgents/` oder
  `~/.local/bin/` ändern. Diese Datei liest nur und legt `~/maschinenraum`
  an, nichts sonst.
- Keine Konten anlegen, nichts installieren.

## Was du mich fragen musst

- ob ich einen zweiten Mac habe, der dauerhaft läuft
- welche Routinen ich in der App sehe

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- Ampel-Ausgabe von pruefen.sh
- Inhalt von betrieb/bestand.md
```

---

## Was jetzt anders ist

Du hast eine eigene Kopie des Werkzeugkastens auf deinem Rechner, und eine
Datei, die zeigt, was du schon hast und was noch fehlt. Jede weitere Lektion
baut darauf auf, ohne dass du dich erinnern musst, was du schon eingerichtet
hast.
