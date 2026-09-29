# Einrichten lassen: ein Job, der ohne App läuft

**Wofür:** Ein echter launchd-Job, der auch läuft, wenn die Claude-App zu
ist. Das Werkzeug `lauf.sh` sorgt dafür, dass der Job denselben PATH
bekommt, den du im Terminal hast (launchd kennt ihn sonst nicht), und dass
jeder Lauf eine Zeile in deiner Laufanzeige hinterlässt, egal ob er
geglückt ist oder nicht.

**So benutzt du diese Datei:** Öffne Claude in dem Projektordner, in dem der
Job laufen soll, und gib ihm den Text unterhalb der Linie, zusammen mit dem
Befehl, der laufen soll, und wie oft.

---

```
Richte mir einen launchd-Job ein, der lauf.sh aus dem Maschinenraum aufruft.

## Ziel

Ein neuer Job unter ~/Library/LaunchAgents/ läuft zu einer festen Uhrzeit,
ruft ~/maschinenraum/werkzeuge/lauf.sh mit meinem Befehl auf, und jeder Lauf
hinterlässt eine Zeile in ~/maschinenraum/betrieb/laufanzeige.md.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Löse einen Probelauf aus:
   launchctl kickstart gui/$(id -u)/<name>
2. Zeig mir nach spätestens einer Minute die letzte Zeile von
   ~/maschinenraum/betrieb/laufanzeige.md. Dort muss "OK" stehen, wenn der
   Befehl erfolgreich war.
3. Zeig mir `launchctl list | grep <name>` mit dem letzten Exitcode.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich: welcher Befehl soll laufen, und wie oft (Uhrzeit, oder jede
   wie-viele Minuten/Stunden)?

3. Erzeuge aus ~/maschinenraum/vorlagen/launchd/job.plist.vorlage eine neue
   Datei ~/Library/LaunchAgents/com.maschinenraum.<name>.plist, mit den
   Platzhaltern ersetzt: {{NAME}}, {{BEFEHL}}, {{STUNDE}}, {{MINUTE}},
   {{HOME}} (mein echtes Heimatverzeichnis, voller Pfad). Zeig mir den
   fertigen Inhalt, bevor du die Datei anlegst, und frag um Erlaubnis, weil
   das ein Eintrag in ~/Library/LaunchAgents/ ist.

4. Prüfe die Datei mit `plutil -lint <datei>`, muss "OK" zurückgeben.

5. Lade den Job:
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.maschinenraum.<name>.plist

6. Führe die Abnahme aus.

## Verbotsliste

- Keinen bestehenden launchd-Job anfassen oder entladen.
- Nichts in ~/Library/LaunchAgents/ ohne mein Ja anlegen oder ändern.
- Im Befehl keine zusätzlichen Schritte einbauen, die ich nicht genannt habe.

## Was du mich fragen musst

- welcher Befehl, welcher Zeitplan
- Erlaubnis, bevor die plist-Datei angelegt wird

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- Name und Zeitplan des Jobs
- die letzte Zeile der Laufanzeige nach dem Probelauf
- wie ich den Job wieder ausschalte (ein Befehl:
  launchctl bootout gui/$(id -u)/com.maschinenraum.<name>)
```

---

## Was jetzt anders ist

Ein Job läuft jetzt auch, wenn du die App zugemacht hast und dein Mac
schläft nicht dazwischen. Du siehst in einer einzigen Datei, ob er
geglückt ist, ohne im Terminal nachsehen zu müssen.
