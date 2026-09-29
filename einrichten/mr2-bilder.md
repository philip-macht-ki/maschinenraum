# Einrichten lassen: Bilder und Schlussprüfung

**Wofür:** Jedes Bild geht an Codex, nie an ein lokales Werkzeug. Und am
Ende eines größeren Baus prüft Codex noch einmal auf Fehler, bevor du es dir
selbst ansiehst.

**So benutzt du diese Datei:** Voraussetzung ist `mr2-codex.md`. Öffne Claude
in einem Projektordner und gib ihm den Text unterhalb der Linie.

---

```
Richte mir die Regeln für Bilder und die Schlussprüfung ein, und lass mir
ein Bild für ein eigenes Vorhaben erzeugen.

## Ziel

Meine CLAUDE.md hat einen Abschnitt "Bilder und Gestaltung". Danach lässt du
mir ein einzelnes Bild für ein Vorhaben erzeugen, das ich dir nenne, siehst
es dir wirklich an und sagst mir, was passt und was nicht.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir per grep, dass "# Bilder und Gestaltung" in der Ziel-CLAUDE.md
   steht.
2. Frag mich nach einem Bildvorhaben (Maße, Inhalt, was nicht vorkommen
   soll). Formuliere daraus einen Auftrag an Codex, zeig ihn mir vor dem
   Abschicken.
3. Nach der Erzeugung: öffne die Bilddatei wirklich (nicht nur `file` oder
   `ls`) und beschreibe mir in eigenen Worten, was zu sehen ist, inklusive
   was NICHT stimmt, falls etwas nicht stimmt.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich, in welche CLAUDE.md der Abschnitt
   (~/maschinenraum/vorlagen/claude-md/bilder.md) soll. Prüfe, ob die
   Überschrift schon drinsteht.
   - Steht sie schon drin: nichts tun.
   - Sonst: Sicherung anlegen, falls die Datei existiert, Text zeigen, erst
     nach meinem Ja anhängen.

3. Führe die Abnahme aus.

## Verbotsliste

- Nichts an einer CLAUDE.md ohne mein Ja ändern.
- Kein Bild ohne vorherige Beschreibung meinerseits erzeugen lassen.
- Keine Variantenreihe erzeugen, nur eine Fassung je Vorhaben.

## Was du mich fragen musst

- welche CLAUDE.md den Bilder-Abschnitt bekommt
- was das Bild zeigen soll, in welchen Maßen, und was nicht vorkommen darf

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob der Abschnitt neu eingefügt wurde
- der Bildauftrag an Codex, wortwörtlich
- Pfad der erzeugten Datei und deine eigene Beschreibung, was zu sehen ist
```

---

## Was jetzt anders ist

Ein Bild entsteht nicht mehr nebenbei und ungesehen. Du bekommst eine
Beschreibung von dem, was tatsächlich auf dem Bild ist, bevor du es
irgendwo einsetzt, und weißt, dass am Ende eines größeren Baus noch einmal
gegengeprüft wird.
