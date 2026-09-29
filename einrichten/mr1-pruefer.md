# Einrichten lassen: der Prüfer

**Wofür:** Ein Helfer, der einer Erfolgsmeldung nicht glaubt, sondern sie
nachprüft. Nützlich, sobald ein anderer Helfer, Codex oder ein Worker sagt
„erledigt", und diese Meldung Folgen hat.

**So benutzt du diese Datei:** Öffne Claude in einem Projektordner und gib
ihm den Text unterhalb der Linie.

---

```
Richte mir den Prüfer aus dem Maschinenraum ein.

## Ziel

~/.claude/agents/pruefer.md liegt bereit. Meldet ein Helfer oder Codex
„erledigt", kann ich das gegenprüfen lassen, statt es zu glauben.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Liste ~/.claude/agents/ auf, zeig, dass pruefer.md dort liegt.
2. Zeig mit diff, dass die Datei genau der Vorlage entspricht.
3. Nimm eine Behauptung, die kürzlich hier im Gespräch gemacht wurde (zum
   Beispiel "diese Datei ist angelegt" oder "der Test läuft"), und lass den
   Prüfer sie in einer neuen Sitzung gegenchecken. Sag mir vorher, dass ich
   dafür eine neue Sitzung öffnen muss.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Prüfe, ob ~/.claude/agents/pruefer.md schon existiert. Existiert sie
   schon, zeig mir den Unterschied zur Vorlage und lass mich entscheiden.

3. Kopiere die Datei unverändert aus ~/maschinenraum/vorlagen/agenten/ nach
   ~/.claude/agents/.

4. Führe die Abnahme aus.

## Verbotsliste

- Keine vorhandene Datei ohne mein Ja überschreiben.

## Was du mich fragen musst

- ob eine vorhandene Datei ersetzt werden soll, falls es eine gibt
- welche Behauptung ich für den Test gegenprüfen lassen will

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob die Datei neu angelegt wurde
- das Urteil des Prüfers aus dem Test, wortwörtlich
```

---

## Was jetzt anders ist

Ein „erledigt" ist ab jetzt eine Behauptung, keine Tatsache, bis sie
nachgeprüft ist. Der Prüfer macht diese Gegenprobe, ohne dass du selbst jede
Datei und jeden Test durchgehen musst.
