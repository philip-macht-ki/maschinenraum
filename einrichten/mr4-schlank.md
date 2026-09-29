# Einrichten lassen: Claude im Skript, schlank

**Wofür:** Ruft ein Skript Claude im Hintergrund auf (`claude -p`), lädt das
normalerweise seine ganze Grundausstattung mit, Werkzeuge, Verbindungen,
CLAUDE.md, für eine Antwort, die oft nur ein paar Sätze lang ist. Mit ein
paar zusätzlichen Schaltern bleibt nur ein Bruchteil davon übrig. Ob die
Antwort dabei für deinen Zweck ausreicht, prüfst du an der konkreten
Aufgabe, nicht vorab pauschal.

**So benutzt du diese Datei:** Öffne Claude in einem Projektordner und gib
ihm den Text unterhalb der Linie.

---

```
Zeig mir den Unterschied zwischen einem normalen und einem schlanken
claude -p Aufruf, an einer echten kleinen Aufgabe.

## Ziel

Ich sehe an einem echten Beispiel, wie viel schneller und günstiger ein
schlanker claude -p Aufruf ist, und habe die richtige Befehlsform notiert,
um sie in eigenen Skripten zu verwenden.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir beide Aufrufe nebeneinander mit ihrer jeweiligen Antwort und
   Laufzeit (`time claude -p …`).
2. Zeig mir den Verbrauch beider Aufrufe. Sag mir dazu: "Zeig mir den
   Verbrauch." statt Tokenzahlen selbst zu behaupten.

## Schritte

1. Frag mich nach einer kleinen, klaren Frage, die sich mit einem Satz
   beantworten lässt (zum Beispiel "ist dieser Satz auf Deutsch grammatisch
   richtig: ...").

2. Führe aus:
   time claude -p "<frage>"
   und danach:
   time claude -p "<frage>" --tools "" --strict-mcp-config \
     --setting-sources "" --system-prompt "Du beantwortest ausschließlich \
     die gestellte Frage, kurz und direkt."

3. Zeig mir beide Antworten und beide Laufzeiten nebeneinander.

4. Schreib das Ergebnis mit Datum nach betrieb/schlank-vergleich.md.

5. Führe die Abnahme aus.

## Verbotsliste

- Keine erfundenen Tokenzahlen nennen, nur was ich selbst über "Zeig mir den
  Verbrauch" abrufe oder was die Kommandozeile direkt anzeigt.

## Was du mich fragen musst

- welche Frage wir für den Vergleich benutzen

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- beide Aufrufe, wortwörtlich
- beide Antworten und Laufzeiten
- der Eintrag in betrieb/schlank-vergleich.md
```

---

## Was jetzt anders ist

Ein Skript, das Claude im Hintergrund braucht, holt jetzt nur noch, was es
wirklich für die Antwort benötigt, statt jedes Mal deine ganze
Grundausstattung mitzuschleppen. Das macht eigene Automatisierungen
schneller und günstiger. Übernimm die schlanke Fassung nur dort, wo du an
deiner eigenen Aufgabe geprüft hast, dass die Antwort ausreicht und sich
der gemessene Unterschied lohnt.
