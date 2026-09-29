# Einrichten lassen: die Regel "Karte zuerst"

**Wofür:** Eine globale Regel, damit jede Sitzung in jedem deiner Projekte
zuerst die Karte fragt, statt gleich Dateien zu durchsuchen oder einen
breiten Such-Helfer zu starten.

**So benutzt du diese Datei:** Voraussetzung ist mindestens eine
eingerichtete Karte. Öffne Claude in einem beliebigen Ordner und gib ihm den
Text unterhalb der Linie.

---

```
Richte mir die Regel "Karte vor Dateilesen" global ein.

## Ziel

~/.claude/CLAUDE.md hat einen Abschnitt, der sagt: in jedem Projekt mit einer
Karte zuerst graphify query/explain/path/affected fragen, erst danach
Dateien lesen.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir per grep, dass die Regel in ~/.claude/CLAUDE.md steht.
2. Stell mir in einer NEUEN Sitzung (sag mir, dass ich sie öffnen muss), in
   einem Projekt mit Karte, eine "Wo hängt X dran"-Frage, und zeig mir, dass
   der erste Schritt ein graphify-Befehl ist, nicht ein Dateilesen oder ein
   Such-Helfer.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Prüfe, ob ~/.claude/CLAUDE.md existiert und ob die Überschrift
   "# Karte vor Dateilesen" schon drinsteht.
   - Steht sie schon drin: nichts tun.
   - Sonst: Sicherung anlegen, falls die Datei existiert, Text aus
     ~/maschinenraum/vorlagen/claude-md/karte.md zeigen, erst nach meinem Ja
     anhängen. Passe darin nur die Namen der Ordner an, die tatsächlich eine
     Karte haben (frag mich danach, falls unklar).

3. Führe die Abnahme aus.

## Verbotsliste

- Nichts an ~/.claude/CLAUDE.md ohne mein Ja ändern.
- Keine Ordner in die Regel schreiben, die keine Karte haben.

## Was du mich fragen musst

- welche Ordner tatsächlich eine Karte haben

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob die Regel neu eingefügt wurde
- das Ergebnis des Tests in der neuen Sitzung
```

---

## Was jetzt anders ist

Jede neue Sitzung fragt jetzt von selbst zuerst deine Karte, bevor sie
anfängt, Dateien zu durchsuchen. Das spart Zeit und Kontext, in jedem
Projekt, das eine Karte hat.
