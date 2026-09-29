# Einrichten lassen: eine SOP für dein Projekt

**Wofür:** Jedes größere Vorhaben bekommt ein eigenes Handbuch im Projektordner.
Darin steht, wie es funktioniert, wo die Wahrheit steht, was schon schiefging
und wo man nachsieht, wenn es klemmt. Dein Claude liest es zuerst, statt jedes
Mal alles neu herauszufinden, und schreibt es nach jeder Änderung fort. Endet
das Vorhaben, verschwindet der Ordner samt Handbuch, und nichts bläht deine
allgemeine Einrichtung auf.

**So benutzt du diese Datei:** Öffne Claude in dem Projektordner, um den es
geht, und sag ihm: Richte mir `einrichten/mr5-sop.md` aus dem Maschinenraum ein.

---

```
Leg mir für dieses Projekt eine SOP an und sorg dafür, dass sie ab jetzt
gelesen und fortgeschrieben wird.

## Ziel

In diesem Projektordner liegt eine Datei SOP_<Kurzname>.md nach der Vorlage
~/maschinenraum/vorlagen/sop/SOP_Vorlage.md, gefüllt mit dem, was du aus den
Dateien hier, der Karte und dem Gedächtnis wirklich belegen kannst. In der
CLAUDE.md dieses Ordners steht ein kurzer Abschnitt, der auf die SOP verweist
und sagt, wann sie gelesen und wann sie fortgeschrieben wird.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir die ersten 40 Zeilen der SOP und sag mir, welche Abschnitte noch
   Platzhalter enthalten, weil du dazu nichts belegen konntest.
2. Zeig mir per grep, dass die CLAUDE.md dieses Ordners den Abschnitt „SOP“
   enthält.
3. Sag mir, ich soll eine neue Sitzung in diesem Ordner öffnen und fragen:
   „Wo schaue ich zuerst nach, wenn hier etwas nicht läuft?“ Die Antwort muss
   aus Abschnitt 9 der SOP kommen.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich nach einem Kurznamen für das Vorhaben (ein Wort, etwa
   „Buchhaltung“ oder „Newsletter“). Gibt es im Ordner schon eine Datei, die
   mit SOP_ beginnt, zeig sie mir und frag, ob du sie ergänzen oder eine neue
   anlegen sollst. Überschreib nie eine bestehende SOP.

3. Sammle, bevor du schreibst:
   - die Dateien in diesem Ordner (bei einer Karte zuerst graphify query mit
     den Stichwörtern des Vorhabens, dann gezielt lesen),
   - die CLAUDE.md dieses Ordners,
   - die Gedächtnisdateien, die zu diesem Projekt gehören (nur lesen),
   - Zeitpläne und Protokolle, die zu diesem Vorhaben gehören, falls es welche
     gibt (~/maschinenraum/betrieb/laufanzeige.md, betrieb/zeitplaene.md).
   Frag mich dann in höchstens fünf kurzen Fragen nach dem, was du nicht
   belegen kannst: Ziel, Regeln, bekannte Fallen, wer Freigaben erteilt.

4. Schreib SOP_<Kurzname>.md nach der Vorlage. Regeln dafür:
   - Nur Belegtes. Was du nicht weißt, bleibt als Platzhalter in spitzen
     Klammern stehen, erfunden wird nichts.
   - Kein Schlüssel, kein Passwort, keine Kontonummer. Bei Zugangsdaten nur
     der Ort, an dem sie liegen.
   - Die Stand-Zeile oben mit heutigem Datum.
   - Alltagssprache, Du-Form nicht nötig, keine Gedankenstriche.
   Zeig mir den Entwurf und leg ihn erst nach meinem Ja an.

5. Schlag mir diesen Abschnitt für die CLAUDE.md in diesem Ordner vor und
   füge ihn erst nach meinem Ja an (Sicherung vorher als
   CLAUDE.md.vor-maschinenraum-<heutiges Datum>, falls die Datei existiert):

   ## SOP
   Wie dieses Vorhaben funktioniert, steht in SOP_<Kurzname>.md. Vor jeder
   Arbeit daran zuerst dort nachlesen, statt es neu herauszufinden.
   Nach jeder Änderung, die das Verhalten ändert, eine neue Falle oder eine
   neue Regel: die SOP im selben Zug fortschreiben (Stand-Zeile oben, der
   Abschnitt, den es betrifft) und mir in einem Satz sagen, was dazukam.
   Endet das Vorhaben, bleibt die SOP im Ordner; es gibt keine Kopie woanders.

6. Führ die Abnahme aus.

Zum Schluss in zwei Sätzen: was jetzt anders ist, und wann du die SOP
fortschreibst.
```
