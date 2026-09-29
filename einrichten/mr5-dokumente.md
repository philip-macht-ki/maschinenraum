# Einrichten lassen: Notizen und PDFs auf die Karte

**Wofür:** Die schnelle Karte kennt nur Code. Der volle Lauf liest auch
Dokumente wie Notizen und PDFs mit, das kostet einmal spürbar Kontingent,
danach nur noch, was neu dazukommt. Am besten klein anfangen, mit einem
einzigen Ordner.

**So benutzt du diese Datei:** Voraussetzung ist eine bestehende Karte in
diesem Ordner. Öffne Claude in dem Projektordner, dessen Dokumente auf die
Karte sollen, und gib ihm den Text unterhalb der Linie.

---

```
Lies auch meine Notizen und PDFs in diesem Ordner auf die Karte.

## Ziel

Eine Frage, deren Antwort nur in einem Dokument steht (nicht im Code),
findet über graphify query trotzdem etwas.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Nenn mir eine Frage, deren Antwort nur in einem deiner Dokumente steht,
   führe graphify query damit aus, und zeig mir, dass die Antwort das
   richtige Dokument nennt.

## Schritte

1. Prüfe nur lesend mit `graphify extract --help`, welche Backends die
   installierte Version tatsächlich unterstützt (`--backend`) und welche
   Authentifizierung sie jeweils braucht. Verlass dich nicht auf eine feste
   Annahme, das ändert sich zwischen Versionen.

2. Sag mir vorher, dass dieser Lauf einmalig spürbar Kontingent kostet, weil
   er Inhalte liest statt nur Code-Struktur. Frag um mein Ja, bevor du
   anfängst.

3. Nach meinem Ja: graphify extract . --backend claude in diesem Ordner
   (Backend "claude", nicht "claude-cli" - der Name aus Schritt 1 sticht
   diese Vorgabe, falls die installierte Version einen anderen Namen zeigt).

4. Führe die Abnahme aus.

## Verbotsliste

- Nicht ohne mein Ja starten, dieser Lauf kostet spürbar mehr als die reine
  Code-Karte.
- Keine anderen Ordner "aus Versehen mitnehmen", nur diesen einen.

## Was du mich fragen musst

- ob der volle Lauf jetzt starten darf
- eine Testfrage, deren Antwort nur in einem Dokument steht

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- welcher Ordner gelesen wurde
- die Testfrage und das Ergebnis von graphify query
```

---

## Was jetzt anders ist

Deine Karte kennt jetzt nicht nur Code, sondern auch, was in deinen eigenen
Notizen und PDFs steht. Eine Frage, die vorher nur durch Nachlesen zu
beantworten war, findet jetzt sofort eine Fundstelle.
