# Einrichten lassen: eine neue Schnittstelle anbinden

**Wofür:** Das immer gleiche Muster, um einen neuen bezahlten Dienst
anzubinden (eine Stimme, ein Bildwerkzeug, ein Mailversand): erst die Doku
lesen, dann den Preis prüfen, dann den Schlüssel ablegen, dann einen
Trockenlauf, erst dann der echte Aufruf.

**So benutzt du diese Datei:** Öffne Claude in einem Projektordner und gib
ihm den Text unterhalb der Linie, zusammen mit dem Namen des Diensts, den du
anbinden willst.

---

```
Bind mir die Schnittstelle von <DIENST> an, nach dem festen Muster für neue
Schnittstellen.

## Ziel

<DIENST> ist angebunden, dokumentiert in betrieb/schnittstellen.md, mit
einem echten Probeaufruf, dessen Kosten ich kenne, bevor er lief.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir den Eintrag zu <DIENST> in betrieb/schnittstellen.md.
2. Zeig mir Ausgabe und Kosten des echten Probeaufrufs.

## Schritte

1. Lies die offizielle Dokumentation von <DIENST> (nicht Blogposts, die
   Herstellerseite selbst), und sag mir in ein bis zwei Sätzen, was der
   Dienst kostet und wie abgerechnet wird (je Aufruf, je Zeichen, je
   Sekunde, im Abo).

2. Frag mich, ob mir dieser Preisrahmen passt, bevor du weitermachst.

3. Frag mich, ob der Schlüssel schon im Schlüsselbund liegt (Dienstname
   <DIENST>). Falls nicht, sag mir den Befehl, den ich selbst ausführe:
   security add-generic-password -s <DIENST> -a "$USER" -w
   Führe ihn nie selbst mit einem Wert aus.

4. Erzwing das Format über einen bewussten Fehlerfall: schick einen Aufruf
   mit einem absichtlich falschen Feld (zum Beispiel einem Text statt einer
   Zahl, wo eine Zahl erwartet wird) und lies die Fehlermeldung. Manche
   Dienste nehmen unbekannte Felder mit Erfolg (HTTP 200) an und werfen sie
   still weg, andere lösen bei einem falsch geformten Aufruf trotzdem einen
   bezahlten Auftrag aus. Zeig mir die Fehlerantwort, bevor du einen echten
   Aufruf machst.

5. Führe erst nach meinem Ja den echten Probeaufruf aus. Zeig mir Antwort
   und, falls die Antwort Kosten oder Verbrauch nennt, diese Zahl.

6. Schreib einen Eintrag nach betrieb/schnittstellen.md: Dienst, Preisrahmen,
   wo der Schlüssel liegt (nur der Dienstname, nie der Wert), Datum des
   Probeaufrufs, Ergebnis.

7. Führe die Abnahme aus.

## Verbotsliste

- Den Schlüssel niemals selbst eintippen, lesen oder in den Chat holen.
- Keinen echten (kostenpflichtigen) Aufruf vor meinem Ja.
- Keine Rückgabewert-Zufriedenheit: ein "Erfolg" (2xx) allein ist kein
  Beweis, das Ergebnis muss am Ziel selbst stimmen (Datei liegt da, Video
  ist da, Kontakt trägt das Feld).

## Was du mich fragen musst

- ob mir der Preisrahmen passt
- ob der Schlüssel schon im Schlüsselbund liegt
- ob der echte Probeaufruf jetzt laufen darf

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- Preisrahmen von <DIENST>
- Ergebnis des Fehlerfall-Aufrufs
- Ergebnis des echten Probeaufrufs, mit Kosten
```

---

## Was jetzt anders ist

Jede neue Schnittstelle bekommt denselben Ablauf: erst verstehen, was sie
kostet, dann einen ungefährlichen Fehlversuch, erst dann Geld ausgeben. Das
verhindert den Fehler, dass ein falsch geformter Testaufruf trotzdem einen
bezahlten Auftrag auslöst.
