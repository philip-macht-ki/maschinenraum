# Einrichten lassen: die Routing-Zeile

**Wofür:** Dein Claude entscheidet vor jeder größeren Aufgabe selbst, wer sie
erledigt, und sagt es dir in einer Zeile, bevor er loslegt.

**So benutzt du diese Datei:** Öffne Claude in dem Projektordner, in dem die
Regel gelten soll, und gib ihm den Text unterhalb der Linie.

---

```
Richte mir die Routing-Regel aus dem Maschinenraum ein.

## Ziel

In einer CLAUDE.md steht die Regel aus ~/maschinenraum/vorlagen/claude-md/routing.md.
Ab jetzt beginnt jede nicht-triviale Antwort mit einer Zeile "Routing: …",
die sagt, wer die Aufgabe übernimmt.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir per grep, dass die Überschrift "# Routing am Aufgabenbeginn" in
   der Zieldatei steht.
2. Stell mir in einer NEUEN Sitzung (sag mir das, ich öffne sie) eine breite
   Frage, die mehrere Dateien betrifft, und zeig mir, dass die erste Zeile
   der Antwort mit "Routing:" beginnt.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich, in welche CLAUDE.md die Regel soll: die allgemeine unter
   ~/.claude/CLAUDE.md (gilt in jedem Projekt) oder die dieses Ordners
   (gilt nur hier). Ohne meine Antwort tust du nichts.

3. Prüfe, ob die Zieldatei existiert. Existiert sie, prüfe, ob die
   Überschrift "# Routing am Aufgabenbeginn" schon drinsteht.
   - Steht sie schon drin: sag mir das, ändere nichts, mach mit der Abnahme
     weiter.
   - Steht sie nicht drin, existiert die Datei aber schon: leg zuerst eine
     Sicherung an unter <datei>.vor-maschinenraum-<heutiges Datum>, zeig mir
     das, und häng den Inhalt von
     ~/maschinenraum/vorlagen/claude-md/routing.md ans Ende an. Zeig mir den
     Text vorher und füge ihn erst nach meinem Ja ein.
   - Existiert die Datei gar nicht: frag, ob du sie neu anlegen sollst, zeig
     mir den vollen Inhalt vorher.

4. Führe die Abnahme aus.

## Verbotsliste

- Nichts in ~/.claude/ oder einer CLAUDE.md ändern, ohne dass ich den Text
  vorher gesehen und bestätigt habe.
- Keine bestehende Zeile in der CLAUDE.md löschen oder umschreiben, nur
  anhängen.
- Keine andere Datei in ~/.claude/ anfassen.

## Was du mich fragen musst

- welche CLAUDE.md
- ob ich den angezeigten Text so anfügen will

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- welche Datei geändert wurde, mit Sicherungsname falls angelegt
- der eingefügte Text
- die erste Zeile der Testantwort aus der neuen Sitzung
```

---

## Was jetzt anders ist

Claude überlegt nicht mehr mitten im Text, wer eine Aufgabe übernehmen
sollte, sondern sagt es dir in einem Satz, bevor er anfängt. Das spart dir
Lesezeit und ihm Kontext, den er sonst fürs Abwägen verbraucht hätte.
