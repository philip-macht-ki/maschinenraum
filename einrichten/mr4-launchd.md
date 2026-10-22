# Einrichten lassen: ein Job, der ohne App läuft

**Wofür:** Ein echter launchd-Job, der auch läuft, wenn die Claude-App zu
ist. Das Werkzeug `lauf.sh` sorgt dafür, dass der Job denselben PATH
bekommt, den du im Terminal hast (launchd kennt ihn sonst nicht), und dass
jeder Lauf eine Zeile in deiner Laufanzeige hinterlässt, egal ob er
geglückt ist oder nicht.

**So benutzt du diese Datei:** Öffne Claude in dem Projektordner, in dem der
Job laufen soll, und gib ihm den Text unterhalb der Linie, zusammen mit dem
Befehl, der laufen soll, und wie oft. Hast du zwei Macs, öffne Claude auf dem
Rechner, der dauerhaft läuft. Ein Job gehört auf genau einen Rechner, und jedes
Jobskript bekommt eine Rechner-Sperre: Auf jedem anderen Mac bricht es ab,
bevor es etwas anfasst.

---

```
Richte mir einen launchd-Job ein, der lauf.sh aus ~/maschinenraum aufruft.

## Ziel

Ein neuer Job unter ~/Library/LaunchAgents/ läuft auf genau diesem Rechner
zu einer festen Uhrzeit,
ruft über ~/maschinenraum/werkzeuge/lauf.sh ein kleines Jobskript mit meinem
Befehl auf, und jeder Lauf hinterlässt eine Zeile in
~/maschinenraum/betrieb/laufanzeige.md.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Löse einen Probelauf aus:
   launchctl kickstart gui/$(id -u)/<name>
2. Warte auf das Ende des Laufs, statt eine feste Minute zu raten: frag
   mich vorher, wie lange der Befehl höchstens dauert, und prüfe danach in
   diesem Rahmen wiederholt (z.B. alle paar Sekunden)
   launchctl print gui/$(id -u)/<name> | grep -E "state|last exit code"
   bis der Zustand nicht mehr "running" ist. Zeig mir danach die letzte
   Zeile von ~/maschinenraum/betrieb/laufanzeige.md. Dort muss "OK" stehen,
   wenn der Befehl erfolgreich war.
3. Zeig mir `launchctl print gui/$(id -u)/<name>` mit dem letzten Exitcode.
4. Zeig mir die Rechner-Sperre im Jobskript und dass der Name darin
   derselbe ist wie die Ausgabe von `hostname -s`.

## Schritte

1. bash ~/maschinenraum/werkzeuge/aktualisieren.sh

2. Zeig mir den Namen dieses Rechners mit `hostname -s` und frag mich, ob
   das der Rechner ist, der dauerhaft läuft. Ist es ein Laptop und ich habe
   einen Dauerrechner, hör hier auf und sag mir, dass ich die Sitzung dort
   starten soll. Schau außerdem in betrieb/zeitplaene.md, ob derselbe Job
   schon auf einem anderen Rechner eingetragen ist. Sag mir ehrlich: Der
   Job läuft ohne offene Claude-App, aber nur, solange dieser Mac an, wach
   und mit meinem Benutzer angemeldet ist. Ein schlafender Mac holt den
   Lauf beim Aufwachen nach, ein ausgeschalteter gar nicht.

   Ruft der Job `claude` auf und fehlt `command -v claude`, führe
   `bash ~/maschinenraum/werkzeuge/claude-starter.sh` aus. Das legt einen
   kleinen Starter in ~/.local/bin an, der die Version aus der Claude-App
   nutzt. Kein Homebrew, kein npm.

3. Frag mich: welcher Befehl soll laufen, wie oft (Uhrzeit, oder jede
   wie-viele Minuten/Stunden), und in welchem Arbeitsordner (voller Pfad -
   wichtig für Befehle mit relativen Pfaden wie "graphify update .").

4. Validiere den Jobnamen: nur [A-Za-z0-9._-]+. Ist er ungültig oder kommt
   von mir mit anderen Zeichen, frag mich nach einem gültigen Namen statt
   ihn selbst zu verändern. Das Label wird com.maschinenraum.<name>.

5. Lege zuerst die Ordner an, die später gebraucht werden (müssen VOR dem
   bootstrap existieren, sonst kann launchd weder das Jobskript noch die
   Log-Datei finden):
   mkdir -p ~/maschinenraum/betrieb/jobs ~/maschinenraum/betrieb/logs

6. Schreibe das eigentliche Jobskript nach
   ~/maschinenraum/betrieb/jobs/<name>.sh:
   #!/bin/bash
   set -euo pipefail
   erlaubt="<Name aus hostname -s, Schritt 2>"
   [ "$(hostname -s)" = "$erlaubt" ] || { echo "Nicht der Dauerrechner $erlaubt, Abbruch"; exit 3; }
   <mein Befehl, so wie ich ihn genannt habe>
   Die zwei Zeilen mit erlaubt sind die Rechner-Sperre. Sie stehen vor dem
   Befehl, damit auf einem anderen Mac nichts angefasst wird, und die
   Laufanzeige zeigt dort FEHLER statt still mitzulaufen. Zeig mir den
   Inhalt, bevor du die Datei anlegst. Mach sie danach
   ausführbar (chmod +x). Der Befehl selbst steht NIE direkt in der plist
   (siehe Schritt 7) - genau das hat früher ungültiges XML erzeugt, sobald
   der Befehl ein "&" enthielt (z.B. eine URL mit mehreren Parametern).

7. Erzeuge die plist ausschließlich per Python (plistlib), nie durch
   Text-Ersetzung in der XML-Vorlage - plistlib escaped Sonderzeichen
   automatisch korrekt:

   python3 - <<'PY'
   import plistlib, os

   name = "com.maschinenraum.<name>"
   home = os.path.expanduser("~")
   jobskript = f"{home}/maschinenraum/betrieb/jobs/<name>.sh"
   arbeitsordner = "<voller Pfad zum Arbeitsordner>"

   daten = {
       "Label": name,
       "ProgramArguments": [
           f"{home}/maschinenraum/werkzeuge/lauf.sh",
           name,
           "--",
           jobskript,
       ],
       "WorkingDirectory": arbeitsordner,
       "EnvironmentVariables": {
           "PATH": f"/opt/homebrew/bin:{home}/.local/bin:/usr/bin:/bin",
       },
       "StartCalendarInterval": {"Hour": <stunde>, "Minute": <minute>},
       "StandardOutPath": f"{home}/maschinenraum/betrieb/logs/{name}.launchd.log",
       "StandardErrorPath": f"{home}/maschinenraum/betrieb/logs/{name}.launchd.log",
   }

   ziel = f"{home}/Library/LaunchAgents/{name}.plist"
   with open(ziel, "wb") as f:
       plistlib.dump(daten, f)
   print(ziel)
   PY

   Zeig mir den fertigen Inhalt (z.B. mit `plutil -p <datei>`), BEVOR du
   die Datei tatsächlich anlegst, und frag um Erlaubnis - das ist ein
   Eintrag in ~/Library/LaunchAgents/.

8. Prüfe die Datei mit `plutil -lint <datei>`, muss "OK" zurückgeben.

9. Lade den Job (die Ordner aus Schritt 5 existieren bereits):
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.maschinenraum.<name>.plist

10. Führe die Abnahme aus.

## Verbotsliste

- Keinen bestehenden launchd-Job anfassen oder entladen.
- Keinen Job einrichten, der laut betrieb/zeitplaene.md schon auf einem
  anderen Rechner läuft.
- Die Rechner-Sperre im Jobskript nie weglassen.
- Nichts in ~/Library/LaunchAgents/ ohne mein Ja anlegen oder ändern.
- Den Befehl nie direkt in die plist schreiben, nur über das Jobskript in
  betrieb/jobs/.
- Im Befehl keine zusätzlichen Schritte einbauen, die ich nicht genannt habe.

## Was du mich fragen musst

- ob dies der Rechner ist, der dauerhaft läuft
- welcher Befehl, welcher Zeitplan, welcher Arbeitsordner
- wie lange der Befehl höchstens dauert (für die Abnahme)
- Erlaubnis, bevor die plist-Datei angelegt wird

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- Name, Zeitplan und Arbeitsordner des Jobs
- die letzte Zeile der Laufanzeige nach dem Probelauf
- wie ich den Job wieder ausschalte, ohne ihn zu löschen. Erst entladen,
  dann die Datei in einen Ordner mit deaktiviert und dem Datum verschieben:
  launchctl bootout gui/$(id -u)/com.maschinenraum.<name>
  mkdir -p ~/Library/LaunchAgents/deaktiviert-$(date +%Y%m%d)
  mv ~/Library/LaunchAgents/com.maschinenraum.<name>.plist ~/Library/LaunchAgents/deaktiviert-$(date +%Y%m%d)/
  Nur bootout reicht nicht: Die Datei bliebe liegen, und beim nächsten
  Anmelden lädt launchd den Job wieder.
```

---

## Was jetzt anders ist

Ein Job läuft jetzt auch, wenn du die App zugemacht hast und dein Mac
schläft nicht dazwischen. Du siehst in einer einzigen Datei, ob er
geglückt ist, ohne im Terminal nachsehen zu müssen.
