# Einrichten lassen: eine Karte über alle deine Projekte

**Wofür:** Du hast schon die Karte eines einzelnen Projektordners. Diese
Lektion macht daraus eine Karte über mehrere Ordner: nach jedem Commit
zeichnet ein Haken die Karte des jeweiligen Repos nach, und einmal pro Nacht
frischt ein Job alle deine Ordner gemeinsam auf.

**So benutzt du diese Datei:** Voraussetzung ist die Karte deines ersten
Projektordners. Öffne Claude in einem beliebigen Ordner und gib ihm den Text
unterhalb der Linie.

---

```
Richte mir eine Karte über alle meine Projektordner ein, mit
Nachzeichnen nach jedem Commit und einem nächtlichen Sammellauf.

## Ziel

Jeder von mir genannte Projektordner, der ein Git-Repo ist, bekommt einen
Haken, der nach jedem Commit seine Karte nachzeichnet. Ein launchd-Job
frischt nachts alle diese Ordner gemeinsam auf und schreibt eine Zeile in
~/maschinenraum/betrieb/laufanzeige.md.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Frag mich zuerst, ob ein Test-Commit in diesem Ordner gefahrlos ist (er
   könnte ein Deployment, einen weiteren Hook oder eine externe Automation
   auslösen). Sagst du ja: mach in diesem Ordner einen kleinen Test-Commit
   (eine Leerzeile in eine Testdatei, dann rückgängig machen) und zeig mir,
   dass danach ein Rebuild angestoßen wurde (Log des Hooks oder neuer
   Zeitstempel von graphify-out/graph.json). Sagst du nein oder bist du
   unsicher: prüf den Hook stattdessen nur lesend (Inhalt der
   Post-Commit-Datei, kein echter Commit) und sag mir, dass die Abnahme
   dafür ohne echten Testlauf gilt.
2. Löse den nächtlichen Job einmal per Hand aus
   (launchctl kickstart gui/$(id -u)/<name>) und zeig mir die neue Zeile in
   der Laufanzeige.
3. Führe in zwei verschiedenen der genannten Projekte je einmal
   graphify query "<ein Stichwort aus diesem Projekt>" aus und zeig, dass
   beide etwas Sinnvolles finden.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich, welche Projektordner (volle Pfade) auf die Karte sollen. Nur
   Ordner, die ich ausdrücklich nenne, keine Annahme.

3. Prüfe je Ordner, ob dort schon graphify-out/ existiert. Fehlt es, frag,
   ob `graphify update .` dort laufen soll (AST-only, ohne Modell).

4. Frag mich für jeden Ordner, der ein Git-Repo ist, ob ein
   Post-Commit-Haken eingerichtet werden soll (`graphify hook install`,
   sofern das Werkzeug diesen Befehl anbietet; sonst sag mir, dass ich es
   selbst nachschlagen soll, statt etwas zu erfinden).

5. Frag mich nach einer Uhrzeit für den nächtlichen Sammellauf (Vorschlag
   06:15, früh am Morgen, damit die Stoßzeiten der App nicht anfallen).

6. Richte dafür einen launchd-Job ein, der werkzeuge/lauf.sh mit einem
   eigenen kleinen Skript aufruft, das `graphify update .` in jedem
   genannten Ordner nacheinander ausführt. Folge dabei genau dem Ablauf aus
   mr4-launchd.md (plist aus der Vorlage, plutil-Prüfung, Erlaubnis vor dem
   Anlegen in ~/Library/LaunchAgents/).

7. Führe die Abnahme aus.

## Verbotsliste

- Keinen Ordner auf die Karte nehmen, den ich nicht ausdrücklich genannt
  habe.
- Keinen bestehenden Post-Commit-Haken oder launchd-Job überschreiben ohne
  mein Ja.
- graphify-out/ in keinem Ordner löschen.

## Was du mich fragen musst

- welche Projektordner
- ob je Ordner ein Post-Commit-Haken eingerichtet werden soll
- die Uhrzeit für den Sammellauf
- Erlaubnis für den launchd-Eintrag
- ob ein Test-Commit in dem jeweiligen Ordner gefahrlos ist

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- welche Ordner jetzt eine Karte und einen Haken haben
- Name und Uhrzeit des nächtlichen Jobs
- die zwei Testergebnisse aus graphify query
```

---

## Was jetzt anders ist

Deine Karte wächst jetzt von selbst mit, in jedem deiner Projekte, nicht nur
in einem. Ein Commit zeichnet seine eigene Karte sofort nach, und einmal pro
Nacht holt ein Sammellauf alles nach, was dabei liegen geblieben ist.
