# Einrichten lassen: die richtigen Orte für deine Zeitpläne

**Wofür:** Jeder wiederkehrende Job läuft an einem von drei Orten:
Cloud-Routine (läuft ohne deinen Mac, sieht deine Dateien nicht),
Desktop-Routine (App muss offen sein, holt nur den letzten verpassten Lauf
nach), oder launchd (läuft ohne offene App, direkt auf deinem Mac). Diese
Lektion sortiert deine eigenen Vorhaben in die richtige Spalte. Und es gilt
immer: eine Aufgabe, ein Rechner. Hast du zwei Macs, läuft jede Aufgabe auf
genau einem davon, dem Dauerrechner. Ein Laptop holt verpasste Läufe beim
Aufklappen nach, und dann passiert alles doppelt.

**So benutzt du diese Datei:** Öffne Claude in dem Projektordner, in dem
deine Jobs laufen sollen, und gib ihm den Text unterhalb der Linie.

---

```
Sortiere meine wiederkehrenden Aufgaben auf die richtigen Orte und schreib
mir eine Tabelle.

## Ziel

betrieb/zeitplaene.md listet jede Aufgabe, die regelmäßig laufen soll, mit
dem passenden Ort (Cloud-Routine, Desktop-Routine, launchd), dem einen
Rechner, auf dem sie läuft, und der Begründung.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir den Inhalt von betrieb/zeitplaene.md.
2. Zeig mir zu jeder Zeile deine Begründung in einem Halbsatz.
3. Keine Aufgabe steht mit zwei Rechnern in der Tabelle.

## Schritte

1. Zeig mir den Namen dieses Rechners mit `hostname -s` und frag mich, ob
   ich einen zweiten Mac habe und welcher der beiden dauerhaft läuft.

2. Frag mich, welche wiederkehrenden Aufgaben ich mir vorstelle oder schon
   habe (Desktop-Routinen, eigene launchd-Jobs). Nutze `launchctl list`, um
   an meinem Benutzernamen erkennbare eigene Jobs zu finden, ohne fremde
   Systemdienste anzufassen.

3. Sortiere jede genannte Aufgabe nach dieser Regel:
   - Muss sie laufen, auch wenn mein Mac aus oder der Deckel zu ist, und
     braucht sie KEINEN Zugriff auf meine lokalen Dateien: Cloud-Routine.
   - Braucht sie Zugriff auf meine lokalen Dateien, aber ich bin
     einverstanden, dass sie ausfällt, wenn die App zu oder der Mac im
     Schlaf ist: Desktop-Routine.
   - Braucht sie Zugriff auf lokale Dateien UND soll auch ohne offene App
     laufen: launchd.

4. Gib jeder Aufgabe genau einen Rechner. Habe ich zwei Macs, ist das für
   Desktop-Routinen und launchd immer der Dauerrechner, nie der Laptop. Eine
   Cloud-Routine braucht keinen Rechner, dort steht Cloud. Läuft eine Aufgabe
   heute schon auf beiden Rechnern, schreib das als Befund dazu, ändere aber
   nichts.

5. Schreib die Tabelle nach betrieb/zeitplaene.md: Aufgabe, Ort, Rechner,
   Begründung, Zeitplan (falls schon entschieden).

6. Führe die Abnahme aus.

## Verbotsliste

- Keinen bestehenden Job oder keine bestehende Routine anfassen oder
  löschen, diese Lektion sortiert nur und schreibt eine Liste.

## Was du mich fragen musst

- ob ich einen zweiten Mac habe und welcher dauerhaft läuft
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
