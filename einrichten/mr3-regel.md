# Einrichten lassen: die Regel für Modelle und Kosten

**Wofür:** Eine feste Regel in deiner CLAUDE.md: Vertrauliches bleibt lokal,
Bezahltes läuft nur mit einer Kostenobergrenze und nach Rückfrage.

**So benutzt du diese Datei:** Öffne Claude in einem Projektordner und gib
ihm den Text unterhalb der Linie.

---

```
Richte mir die Regel "Modelle und Kosten" aus dem Maschinenraum ein.

## Ziel

Meine CLAUDE.md hat einen Abschnitt "Modelle und Kosten". Ab jetzt fragt eine
neue Sitzung vor jedem bezahlten Aufruf nach und nennt eine Obergrenze, statt
einfach loszulegen.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir per grep, dass "# Modelle und Kosten" in der Ziel-CLAUDE.md
   steht.
2. Stell mir in einer NEUEN Sitzung (sag mir, dass ich sie öffnen muss) eine
   Aufgabe, die einen bezahlten Aufruf brauchen würde, und zeig mir, dass
   sie vorher nach einer Obergrenze fragt statt loszulegen.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich, in welche CLAUDE.md der Abschnitt
   (~/maschinenraum/vorlagen/claude-md/modelle.md) soll. Prüfe, ob die
   Überschrift schon drinsteht.
   - Steht sie schon drin: nichts tun.
   - Sonst: Sicherung anlegen, falls die Datei existiert, Text zeigen, erst
     nach meinem Ja anhängen.

3. Führe die Abnahme aus.

## Verbotsliste

- Nichts an einer CLAUDE.md ohne mein Ja ändern.

## Was du mich fragen musst

- welche CLAUDE.md den Abschnitt bekommt

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob der Abschnitt neu eingefügt wurde
- das Ergebnis des Tests in der neuen Sitzung
```

---

## Was jetzt anders ist

Ein bezahlter Aufruf passiert nicht mehr nebenbei. Du bekommst vorher eine
Zahl genannt und musst zustimmen, und Vertrauliches bleibt von Anfang an auf
deinem eigenen Rechner.
