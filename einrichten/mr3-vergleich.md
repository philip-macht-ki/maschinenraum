# Einrichten lassen: derselbe Vergleich, lokal und mit Claude

**Wofür:** Ein ehrlicher Vergleich, was dein lokales Modell wirklich taugt
und was nicht. Sortieren und Umbenennen ja, ein feines Urteil oder gutes
Deutsch eher nein.

**So benutzt du diese Datei:** Voraussetzung ist `mr3-ollama.md`. Öffne
Claude in einem Projektordner und gib ihm den Text unterhalb der Linie.

---

```
Lass mich dasselbe Problem einmal von meinem lokalen Modell und einmal von
dir lösen, damit ich weiß, wofür welches taugt.

## Ziel

Ich habe eine Aufgabe aus meinem eigenen Alltag zweimal lösen lassen, einmal
vom lokalen Modell, einmal von dir. Ein Satz in betrieb/vergleich.md hält
fest, was ich daraus gelernt habe.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir beide Antworten nebeneinander.
2. Zeig mir den Eintrag in betrieb/vergleich.md.

## Schritte

1. Frag mich nach einer echten, kleinen Aufgabe aus meinem Alltag, die sich
   in ein bis zwei Sätzen beschreiben lässt (zum Beispiel: eine E-Mail
   zusammenfassen, einen Satz auf Deutsch prüfen, eine Liste sortieren).

2. Lass die Aufgabe über `ollama run <modell> "<aufgabe>"` laufen, und stell
   mir dieselbe Aufgabe hier in der Sitzung.

3. Zeig mir beide Antworten. Sag mir ehrlich, wenn eine davon falsch,
   unklar oder auf Englisch ist, auch wenn es die lokale ist.

4. Frag mich in einem Satz, was ich daraus mitnehme, und schreib das nach
   ~/maschinenraum/betrieb/vergleich.md mit Datum.

5. Führe die Abnahme aus.

## Verbotsliste

- Keine Bewertung schönreden. Ein falsches lokales Ergebnis bleibt falsch in
  der Notiz.

## Was du mich fragen musst

- welche Aufgabe wir vergleichen
- was ich daraus mitnehme

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- die Aufgabe
- beide Antworten
- mein Satz in betrieb/vergleich.md
```

---

## Was jetzt anders ist

Du weißt jetzt aus eigener Erfahrung, nicht vom Hörensagen, wofür dein
lokales Modell reicht und wofür nicht. Das entscheidet ab jetzt, wohin eine
Aufgabe geht.
