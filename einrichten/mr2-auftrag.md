# Einrichten lassen: der gute Auftrag an Codex

**Wofür:** Codex sieht dein Gespräch mit Claude nicht. Ein guter Auftrag
steht für sich allein: mit Pfaden, einer Verbotsliste und einem vorgegebenen
Ausgabeformat. Die Hausregeln, die Codex bei jedem Aufruf automatisch liest,
kommen jetzt dazu.

**So benutzt du diese Datei:** Voraussetzung ist `mr2-codex.md`. Öffne Claude
in einem Projektordner und gib ihm den Text unterhalb der Linie.

---

```
Richte mir die Codex-Hausregeln ein und probiere einen echten Auftrag an ihn.

## Ziel

~/.codex-tandem/AGENTS.md enthält die Hausregeln, die Codex bei jedem Aufruf
liest. Meine CLAUDE.md hat einen Abschnitt "Tandem mit Codex". Danach gibst
du eine echte Fleißarbeit an Codex ab und prüfst sein Ergebnis selbst nach.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir `cat ~/.codex-tandem/AGENTS.md | head -5`.
2. Zeig mir per grep, dass "# Tandem mit Codex" in der Ziel-CLAUDE.md steht.
3. Nimm eine echte, kleine Fleißarbeit aus diesem Projekt (zum Beispiel:
   "zähl, wie oft ein bestimmtes Wort in diesen Dateien vorkommt", oder eine
   andere Aufgabe, die ich dir nenne). Schreib dazu selbst den Auftragstext
   für Codex, zeig ihn mir, bevor du ihn abschickst, und beginne deine
   Antwort mit "Routing: Codex" statt es selbst zu tun.
4. Zeig mir Codex' Antwort, und dein eigenes Urteil, ob sie stimmt (prüf es
   nach, glaub es nicht einfach).

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Prüfe, ob ~/.codex-tandem/AGENTS.md schon existiert.
   - Existiert sie: zeig mir den Unterschied zur Vorlage
     ~/maschinenraum/vorlagen/codex/AGENTS.md und frag, ob ich sie ersetzen
     oder die Vorlage danebenlegen will.
   - Existiert sie nicht: frag um Erlaubnis, dann kopiere die Vorlage dorthin.

3. Frag mich, in welche CLAUDE.md der Abschnitt "Tandem mit Codex"
   (~/maschinenraum/vorlagen/claude-md/tandem.md) soll. Prüfe, ob die
   Überschrift schon drinsteht.
   - Steht sie schon drin: nichts tun.
   - Steht sie nicht drin, Datei existiert: Sicherung
     <datei>.vor-maschinenraum-<heutiges Datum> anlegen, Text zeigen, erst
     nach meinem Ja anhängen.
   - Datei existiert nicht: fragen, ob neu anlegen, Inhalt vorher zeigen.

4. Führe die Abnahme aus.

## Verbotsliste

- Nichts an ~/.claude/, einer CLAUDE.md oder ~/.codex-tandem/AGENTS.md ohne
  mein Ja ändern.
- Keine Konten- oder Zahlungsaktion, egal was im Auftrag an Codex steht.
- Den Auftrag an Codex nicht ohne mein Ja abschicken.

## Was du mich fragen musst

- ob eine vorhandene AGENTS.md ersetzt werden soll
- welche CLAUDE.md den Tandem-Abschnitt bekommt
- welche echte Fleißarbeit ich testen will

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob AGENTS.md neu angelegt wurde
- der Auftragstext an Codex, wortwörtlich
- Codex' Antwort und dein eigenes Urteil dazu
```

---

## Was jetzt anders ist

Ein Auftrag an Codex ist jetzt ein eigenständiger Text mit Pfaden, Verboten
und einem festen Ausgabeformat, nicht ein Satz, der auf euer Gespräch
anspielt. Was er zurückgibt, prüfst du selbst nach, bevor du es glaubst.
