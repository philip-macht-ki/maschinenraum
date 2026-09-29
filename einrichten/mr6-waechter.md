# Einrichten lassen: ein Wächter für alle deine Jobs

**Wofür:** Ein Wächter schaut jeden Morgen über alle deine Laufanzeigen und
deine launchd-Jobs und meldet sich per Mac-Mitteilung nur, wenn etwas fehlt
oder rot ist. Bleibt etwas stehen, erfährst du es, statt es Tage später
zufällig zu bemerken.

**So benutzt du diese Datei:** Öffne Claude in einem beliebigen Ordner und
gib ihm den Text unterhalb der Linie.

---

```
Richte mir den Wächter aus dem Maschinenraum ein, und löse absichtlich einen
Fehler aus, um ihn zu testen.

## Ziel

Ein launchd-Job ruft jeden Morgen werkzeuge/waechter.sh auf. Läuft etwas
nicht wie erwartet, bekomme ich eine Mac-Mitteilung, und
betrieb/waechter.md zeigt den Grund.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Löse absichtlich einen Fehler aus (zum Beispiel: einen Testjob über
   werkzeuge/lauf.sh mit einem Befehl, der garantiert scheitert, etwa
   `false`) und führe danach werkzeuge/waechter.sh aus. Zeig mir, dass
   betrieb/waechter.md diesen Fehler nennt.
2. Frag mich, ob eine Mitteilung auf dem Bildschirm erschienen ist. Das
   kannst du nicht sehen, das musst du mich fragen.
3. Zeig mir dieselbe Prüfung mit MR_TEST=1 waechter.sh, und zeig mir die
   Protokollzeile, die stattdessen geschrieben wurde.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich, ob es außer der eigenen Laufanzeige noch weitere gibt, die der
   Wächter mitlesen soll (zum Beispiel die eines Werkstatt-Projektordners),
   und ob es Jobs mit bekanntem erwartetem Takt gibt (zum Beispiel "läuft
   täglich", "läuft stündlich"). Trag beides in
   ~/maschinenraum/betrieb/waechter.conf ein, nach dem Muster, das in
   werkzeuge/waechter.sh als Kommentar steht.

3. Richte einen launchd-Job ein, der morgens werkzeuge/waechter.sh aufruft,
   genau nach dem Ablauf aus mr4-launchd.md (Vorlage, plutil-Prüfung,
   Erlaubnis vor dem Eintrag in ~/Library/LaunchAgents/).

4. Führe die Abnahme aus.

## Verbotsliste

- Keinen bestehenden Job in waechter.conf falsch benennen oder erfinden,
  nur eintragen, was ich dir nenne.
- MR_TEST=1 nur für den Test benutzen, der echte Job läuft ohne dieses Flag.

## Was du mich fragen musst

- weitere Laufanzeigen und erwartete Takte für waechter.conf
- ob eine Mitteilung auf dem Bildschirm erschienen ist
- Erlaubnis für den launchd-Eintrag

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- Inhalt von waechter.conf
- der Befund aus betrieb/waechter.md nach dem absichtlichen Fehler
- ob die Mitteilung erschienen ist
```

---

## Was jetzt anders ist

Du musst nicht mehr selbst nachsehen, ob in der Nacht etwas schiefgegangen
ist. Bleibt ein Job stehen oder läuft er seltener als erwartet, meldet sich
der Wächter von selbst, und du siehst den Grund in einer Datei.
