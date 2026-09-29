# Einrichten lassen: ein Hook, der sich von selbst meldet

**Wofür:** Ein Hook heißt "jedes Mal, wenn X passiert, dann Y", ohne dass du
fragst. Diese Lektion richtet einen Hook ein, der beim Start jeder neuen
Sitzung von selbst zeigt, ob in deiner Laufanzeige seit dem letzten Mal ein
Fehler aufgetaucht ist.

**So benutzt du diese Datei:** Öffne Claude in einem beliebigen Ordner und
gib ihm den Text unterhalb der Linie.

---

```
Richte mir den Sitzungsstart-Hook aus dem Maschinenraum ein.

## Ziel

~/.claude/hooks/sitzungsstart.sh liegt bereit und ist in
~/.claude/settings.json unter SessionStart eingetragen. Jede neue Sitzung
zeigt von selbst, ob seit dem letzten Mal ein FEHLER in der Laufanzeige
steht.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir `cat ~/.claude/hooks/sitzungsstart.sh | head -5`.
2. Zeig mir per `python3 -c "import json; print(json.load(open('...'))
   ['hooks']['SessionStart'])"` (oder ähnlich), dass der Eintrag in
   settings.json steht.
3. Öffne (sag mir, dass ich das tun muss) eine neue Sitzung mit einer
   absichtlich falschen Laufanzeige-Zeile ("FEHLER" hineingeschrieben) und
   zeig, dass sie beim Start erscheint. Räum die Testzeile danach wieder
   weg.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich, ob ich neben ~/maschinenraum/betrieb/laufanzeige.md noch eine
   weitere Laufanzeige habe (zum Beispiel die eines anderen Projektordners),
   die der Hook mitlesen soll. Trag den vollen Pfad ein, falls ja.

3. Prüfe, ob ~/.claude/hooks/sitzungsstart.sh schon existiert. Existiert sie,
   zeig mir den Unterschied zur Vorlage und lass mich entscheiden.
   Kopiere sie sonst aus ~/maschinenraum/vorlagen/hooks/sitzungsstart.sh,
   trag den zusätzlichen Pfad aus Schritt 2 ein, falls genannt, und mach sie
   ausführbar.

4. Prüfe die Datei mit `bash -n`.

5. Lies ~/.claude/settings.json. Existiert die Datei nicht, frag, ob du sie
   neu anlegen darfst. Existiert sie: leg zuerst eine Sicherung an
   (~/.claude/settings.json.vor-maschinenraum-<heutiges Datum>), zeig mir
   den geplanten Unterschied, und füge den SessionStart-Eintrag erst nach
   meinem Ja per python3 sauber in das bestehende JSON ein (nicht die Datei
   neu schreiben, nur den einen Schlüssel ergänzen oder erweitern). Prüfe
   danach mit `python3 -c "import json; json.load(open('...'))"`, dass die
   Datei gültiges JSON ist.

6. Führe die Abnahme aus.

## Verbotsliste

- ~/.claude/settings.json nie komplett überschreiben, nur den einen
  Hook-Eintrag ergänzen oder erweitern, alles andere bleibt unangetastet.
- Keine Sicherung ohne vorheriges Anlegen einer neuen Änderung.
- Keinen anderen Hook-Typ (PreToolUse, PostToolUse, Stop) anfassen.

## Was du mich fragen musst

- ob es eine zweite Laufanzeige gibt, die mitgelesen werden soll
- Erlaubnis, bevor settings.json geändert wird

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob settings.json neu angelegt oder geändert wurde, mit Sicherungsname
- das Ergebnis des Fehlerfall-Tests
```

---

## Was jetzt anders ist

Jede neue Sitzung beginnt jetzt von selbst mit dem Stand deiner
Laufanzeige, du musst nicht mehr danach fragen. Bleibt die Meldung aus, ist
seit dem letzten Mal kein Job schiefgegangen.
