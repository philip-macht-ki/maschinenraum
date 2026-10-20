# Werkzeugkasten zum Claude-Profi-Setup

Das hier ist keine App und kein Programm, das du selbst bedienen musst. Es
ist eine Sammlung von Bauplänen für Dinge, die im Hintergrund für dich
laufen: ein Helfer, der Fleißarbeit übernimmt, eine Karte deiner eigenen
Dateien, ein Zeitplan, der auch läuft, wenn dein Rechner schläft, und ein
Wächter, der sich meldet, wenn etwas stehen bleibt.

Du musst nichts davon selbst programmieren. Zu jedem Baustein gibt es eine
Datei unter `einrichten/`, die du deinem eigenen Claude gibst.

## Erst: auf welchem Rechner?

Hast du zwei Macs, etwa einen Mac mini und einen Laptop, kommt der
Werkzeugkasten nur auf den Rechner, der dauerhaft läuft. Dort liegen dein
Claude, deine Helfer und jeder Zeitplan. Der Laptop ist nur das Fenster: Du
arbeitest an ihm, aber jede Sitzung läuft auf dem Dauerrechner, über die
SSH-Umgebung in der Claude-App, über Remote Control oder die
Bildschirmfreigabe. Jede geplante Aufgabe läuft auf genau einem Rechner, sonst
holt der Laptop sie beim Aufklappen nach und alles passiert doppelt. Wie du das
einrichtest, steht im Kurs Der Dauerläufer.

## So benutzt du das

1. Hol dir dieses Repo einmal nach `~/maschinenraum`, auf dem Dauerrechner,
   falls du einen hast. Sag deinem Claude:
   „Hol dir dieses Repo nach `~/maschinenraum` und richte
   `einrichten/mr0-bestand.md` ein."
2. Für jeden weiteren Baustein: Sag deinem Claude „Richte mir `<datei>` aus
   ~/maschinenraum ein." und nenn ihm den Dateinamen aus `einrichten/`.
3. Jede Einrichtung fragt dich, bevor sie etwas an deinen Grundeinstellungen
   ändert, und zeigt dir am Ende, dass sie wirklich funktioniert, nicht nur,
   dass sie es behauptet.

## Ein Blick auf den Stand

```
bash pruefen.sh
```

zeigt eine Ampel: was schon eingerichtet ist, was fehlt, was freiwillig ist.
Ganz oben stehen der Name des Rechners, ob er schläft und ob Time Machine ein
Ziel hat. So siehst du sofort, ob du gerade auf dem Dauerrechner bist.

## Was hier drinsteckt

- `einrichten/`: die Aufträge für deinen Claude, einer je Baustein
- `vorlagen/`: die eigentlichen Textbausteine und Skripte, die die Aufträge
  verwenden
- `werkzeuge/`: kleine Skripte, die auf deinem Rechner laufen (Zeitplan
  starten, Wächter, Schlüssel lesen)
- `betrieb/`: hier entstehen deine eigenen Protokolle und Notizen, leer bei
  der Installation

## Was du selbst tun musst

Ein paar Dinge kann kein Claude für dich erledigen: ein Abo abschließen, im
Browser eine Anmeldung bestätigen, einen Schlüssel selbst eintippen, oder
entscheiden, ob dir ein Preis passt. Genau diese Stellen sind in jeder
Einrichtungsdatei klar markiert.

## Lizenz

MIT, siehe `LICENSE`.
