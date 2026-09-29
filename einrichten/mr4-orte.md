# Einrichten lassen: die richtigen Orte für deine Zeitpläne

**Wofür:** Jeder wiederkehrende Job läuft an einem von drei Orten:
Cloud-Routine (läuft ohne deinen Mac, sieht deine Dateien nicht),
Desktop-Routine (App muss offen sein, holt nur den letzten verpassten Lauf
nach), oder launchd (läuft ohne offene App, direkt auf deinem Mac). Diese
Lektion sortiert deine eigenen Vorhaben in die richtige Spalte.

**So benutzt du diese Datei:** Öffne Claude in dem Projektordner, in dem
deine Jobs laufen sollen, und gib ihm den Text unterhalb der Linie.

---

```
Sortiere meine wiederkehrenden Aufgaben auf die richtigen Orte und schreib
mir eine Tabelle.

## Ziel

betrieb/zeitplaene.md listet jede Aufgabe, die regelmäßig laufen soll, mit
dem passenden Ort (Cloud-Routine, Desktop-Routine, launchd) und der
Begründung.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir den Inhalt von betrieb/zeitplaene.md.
2. Zeig mir zu jeder Zeile deine Begründung in einem Halbsatz.

## Schritte

1. Frag mich, welche wiederkehrenden Aufgaben ich mir vorstelle oder schon
   habe (Desktop-Routinen, eigene launchd-Jobs). Nutze `launchctl list`, um
   an meinem Benutzernamen erkennbare eigene Jobs zu finden, ohne fremde
   Systemdienste anzufassen.

2. Sortiere jede genannte Aufgabe nach dieser Regel:
   - Muss sie laufen, auch wenn mein Mac aus oder der Deckel zu ist, und
     braucht sie KEINEN Zugriff auf meine lokalen Dateien: Cloud-Routine.
   - Braucht sie Zugriff auf meine lokalen Dateien, aber ich bin
     einverstanden, dass sie ausfällt, wenn die App zu oder der Mac im
     Schlaf ist: Desktop-Routine.
   - Braucht sie Zugriff auf lokale Dateien UND soll auch ohne offene App
     laufen: launchd.

3. Schreib die Tabelle nach betrieb/zeitplaene.md: Aufgabe, Ort, Begründung,
   Zeitplan (falls schon entschieden).

4. Führe die Abnahme aus.

## Verbotsliste

- Keinen bestehenden Job oder keine bestehende Routine anfassen oder
  löschen, diese Lektion sortiert nur und schreibt eine Liste.

## Was du mich fragen musst

- welche Aufgaben ich mir vorstelle oder schon eingerichtet habe

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

- die Tabelle aus betrieb/zeitplaene.md
```

---

## Was jetzt anders ist

Jede deiner wiederkehrenden Aufgaben hat jetzt einen begründeten Platz,
statt einfach dort zu landen, wo es gerade am einfachsten war. Das nächste
Mal, wenn du einen neuen Job einrichtest, schaust du erst in diese Tabelle.
