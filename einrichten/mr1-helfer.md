# Einrichten lassen: Sichter und Web-Rechercheur

**Wofür:** Zwei weitere Helfer kommen dazu: einer dampft lange Ausgaben wie
Logs oder Exporte auf eine Antwort ein, der andere recherchiert im Netz und
bringt Belege statt Vermutungen mit. Beide sparen deiner Hauptsitzung
Kontext, der sonst mit Rohdaten volllaufen würde.

**So benutzt du diese Datei:** Voraussetzung ist, dass der Rechercheur aus
deiner Werkstatt-Woche zur Delegation schon eingerichtet ist. Öffne Claude in
einem Projektordner und gib ihm den Text unterhalb der Linie.

---

```
Richte mir die Helfer sichter und web-rechercheur aus dem Maschinenraum ein.

## Ziel

~/.claude/agents/sichter.md und web-rechercheur.md liegen bereit. In einer
neuen Sitzung kann ich eine große Logdatei oder eine Marktfrage an den
passenden Helfer geben und bekomme nur den Befund zurück.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Liste ~/.claude/agents/ auf und zeig, dass sichter.md und
   web-rechercheur.md dort liegen.
2. Zeig mit diff, dass beide Dateien genau den Vorlagen aus
   ~/maschinenraum/vorlagen/agenten/ entsprechen.

Beide Helfer startest du in DIESER Sitzung nicht, sie sind hier noch nicht
aufrufbar. Das probierst du in einer neuen Sitzung.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Prüfe, ob ~/.claude/agents/sichter.md oder web-rechercheur.md schon
   existieren. Existiert eine davon schon, zeig mir den Unterschied zur
   Vorlage und lass mich entscheiden, ob ich sie ersetzen will. Ohne mein Ja
   überschreibst du nichts.

3. Kopiere die fehlenden oder freigegebenen Dateien unverändert aus
   ~/maschinenraum/vorlagen/agenten/ nach ~/.claude/agents/. Ändere nichts am
   Inhalt, auch nicht die Modellangabe (beide bleiben auf Sonnet).

4. Führe die Abnahme aus.

5. Sag mir: "Öffne eine neue Sitzung, dann kannst du sichter oder
   web-rechercheur ausprobieren, zum Beispiel mit einer echten Logdatei oder
   einer echten Marktfrage."

## Verbotsliste

- Keine vorhandene Agent-Datei ohne mein Ja überschreiben.
- Keine andere Datei in ~/.claude/agents/ anfassen oder löschen.

## Was du mich fragen musst

- ob eine vorhandene Datei ersetzt werden soll, falls es eine gibt

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- welche Dateien neu angelegt wurden
- Ergebnis des diff-Vergleichs
```

---

## Was jetzt anders ist

Eine lange Logdatei oder eine Recherche mit vielen offenen Browser-Tabs muss
nicht mehr deine Hauptsitzung füllen. Du gibst die Aufgabe einem der beiden
Helfer und bekommst nur zurück, was du wirklich wissen wolltest.
