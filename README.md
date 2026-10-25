# Werkzeugkasten zum Claude-Profi-Setup

Das hier ist keine App und kein Programm, das du selbst bedienen musst. Es
ist eine Sammlung von Bauplänen für Dinge, die im Hintergrund für dich
laufen: ein Helfer, der Fleißarbeit übernimmt, eine Karte deiner eigenen
Dateien, ein Zeitplan, der ohne offene App läuft, solange dein Mac wach ist, und ein
Wächter, der sich meldet, wenn etwas stehen bleibt.

Du musst nichts davon selbst programmieren. Zu jedem Baustein gibt es eine
Datei unter `einrichten/`, die du deinem eigenen Claude gibst.

## So benutzt du das

Du brauchst kein GitHub-Konto und tippst keinen Befehl.

1. Sag deinem Claude einmal:
   „Hol dir den Werkzeugkasten von github.com/philip-macht-ki/maschinenraum
   nach `~/maschinenraum` und richte `einrichten/mr0-bestand.md` ein."
   Er lädt das öffentliche Archiv, ganz ohne Anmeldung.
2. Für jeden weiteren Baustein: Sag deinem Claude „Richte mir `<datei>` aus
   ~/maschinenraum ein." und nenn ihm den Dateinamen aus `einrichten/`.
3. Jede Einrichtung fragt dich, bevor sie etwas an deinen Grundeinstellungen
   ändert, und zeigt dir am Ende, dass sie wirklich funktioniert, nicht nur,
   dass sie es behauptet.

Vor jeder Einrichtung oder Änderung führt dein Claude zuerst `bash werkzeuge/aktualisieren.sh` aus; es holt die neueste Fassung und bewahrt deine Einstellungen und Inhalte. Es zeigt dir den alten und den neuen Stand und welche Dateien sich geändert haben; die Kennung steht in `betrieb/stand.txt`.
Hast du selbst eine Datei außerhalb von `betrieb/` geändert, wird sie vor
dem Überschreiben als `<datei>.vor-update-<datum>` gesichert. Deine eigenen
Dateien in `betrieb/` bleiben ohnehin unberührt.

## Ein Rechner oder zwei?

Teil 1 und 2 laufen auf jedem Mac. Zeitpläne aus Teil 3 laufen nur, solange
der Mac an, wach und mit deinem Benutzer angemeldet ist. Hast du zwei Macs,
gehört jeder Zeitplan auf genau einen davon, am besten den, der dauerhaft
läuft. Sonst holt der Laptop verpasste Läufe beim Aufklappen nach, und alles
passiert doppelt.

Der Laptop kann dabei das Fenster sein: Du arbeitest an ihm, aber die
Sitzung läuft auf dem Rechner, der dauerhaft läuft, etwa über die
SSH-Umgebung der Claude-App, über Remote Control oder die
Bildschirmfreigabe von macOS.

## Ein Blick auf den Stand

`pruefen.sh` zeigt eine Ampel: was schon eingerichtet ist, was fehlt, was
freiwillig ist. Ganz oben stehen der Name des Rechners, ob er schläft und ob
ein Backup eingerichtet ist. Gelb heißt: freiwillig oder erst später nötig.
Rot heißt: Teil 1 braucht es jetzt.

## Was hier drinsteckt

- `einrichten/`: die Aufträge für deinen Claude, einer je Baustein
- `vorlagen/`: die eigentlichen Textbausteine und Skripte, die die Aufträge
  verwenden
- `werkzeuge/`: kleine Skripte, die auf deinem Rechner laufen (aktualisieren,
  Zeitplan starten, Wächter, Schlüssel lesen)
- `betrieb/`: hier entstehen deine eigenen Protokolle und Notizen, leer bei
  der Installation

## Was du selbst tun musst

Ein paar Dinge kann kein Claude für dich erledigen: ein Abo abschließen, im
Browser eine Anmeldung bestätigen, einen Schlüssel selbst eintippen, oder
entscheiden, ob dir ein Preis passt. Genau diese Stellen sind in jeder
Einrichtungsdatei klar markiert.

## Lizenz

MIT, siehe `LICENSE`.
