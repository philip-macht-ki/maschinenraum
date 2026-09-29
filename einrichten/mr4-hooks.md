# Einrichten lassen: ein Hook, der sich von selbst meldet

**Wofür:** Ein Hook heißt "jedes Mal, wenn X passiert, dann Y", ohne dass du
fragst. Diese Lektion richtet einen Hook ein, der beim Start jeder neuen
Sitzung von selbst zeigt, ob in deiner Laufanzeige seit dem LETZTEN
Sitzungsstart ein neuer Fehler aufgetaucht ist (nicht jeder alte erneut).

**So benutzt du diese Datei:** Öffne Claude in einem beliebigen Ordner und
gib ihm den Text unterhalb der Linie.

---

```
Richte mir den Sitzungsstart-Hook aus dem Maschinenraum ein.

## Ziel

~/.claude/hooks/sitzungsstart.sh liegt bereit und ist in
~/.claude/settings.json unter hooks.SessionStart eingetragen. Jede neue
Sitzung zeigt von selbst, ob seit der letzten Sitzung ein neuer FEHLER in
der Laufanzeige aufgetaucht ist. Alte, schon gezeigte Fehler erscheinen
nicht erneut.

## Das genaue Zielschema

Claude Code erwartet in settings.json exakt diese Struktur (SessionStart
ist eine Liste von Gruppen, jede Gruppe hat ein "hooks"-Array mit
{"type":"command","command":...}; ein optionales "matcher"-Feld schränkt
auf bestimmte Start-Arten ein, z.B. "startup|resume" - fehlt es, greift der
Hook bei jedem SessionStart-Ereignis):

    {
      "hooks": {
        "SessionStart": [
          {
            "hooks": [
              {
                "type": "command",
                "command": "~/.claude/hooks/sitzungsstart.sh"
              }
            ]
          }
        ]
      }
    }

Beim tatsächlichen Einrichten löst du (Claude) `~` selbst in den lokalen
Pfad des Mitglieds auf, bevor der Eintrag geschrieben wird.

Bestehende Einträge unter "hooks" (auch andere Ereignisse wie PreToolUse
oder ein schon vorhandener SessionStart-Eintrag eines anderen Werkzeugs)
bleiben unverändert stehen - es wird nur eine weitere Gruppe ergänzt, nie
die Liste ersetzt. Bevor du daran etwas änderst: sieh dir zur Orientierung
dein eigenes Wissen über das aktuelle SessionStart-Schema an, und wenn du
unsicher bist, lies NUR LESEND ~/.claude/settings.json als echtes Beispiel
dafür, wie ein "hooks"-Objekt in der Praxis aussieht (nicht kopieren, nur
zur Orientierung - fremde Einträge dort bleiben unangetastet).

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir `cat ~/.claude/hooks/sitzungsstart.sh | head -5`.
2. Zeig mir per
   `python3 -c "import json; print(json.load(open(...))['hooks']['SessionStart'])"`
   (Pfad zu ~/.claude/settings.json einsetzen), dass der Eintrag mit genau
   diesem command-Pfad in der Liste steht.
3. Häng eine eindeutig markierte Testzeile an
   ~/maschinenraum/betrieb/laufanzeige.md an, z.B.:
   9999-99-99 00:00 | mr4-hooks-test | FEHLER | Testzeile fuer die Abnahme, gefahrlos entfernbar
   Sag mir danach ausdrücklich, dass ICH selbst eine neue Sitzung öffnen
   muss (das kannst du nicht für mich auslösen), und dass ich dir zeigen
   soll, was beim Start erscheint. Warte auf meine Rückmeldung.
4. Entferne anschließend GENAU diese eine Testzeile wieder (am eindeutigen
   Text "mr4-hooks-test" erkennbar), keine andere Zeile der Laufanzeige.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich, ob ich neben ~/maschinenraum/betrieb/laufanzeige.md noch eine
   weitere Laufanzeige habe (zum Beispiel die eines anderen Projektordners),
   die der Hook mitlesen soll. Trag den vollen Pfad ein, falls ja.

3. Prüfe, ob ~/.claude/hooks/sitzungsstart.sh schon existiert. Existiert sie,
   zeig mir den Unterschied zur Vorlage und lass mich entscheiden.
   Kopiere sie sonst aus ~/maschinenraum/vorlagen/hooks/sitzungsstart.sh,
   trag den zusätzlichen Pfad aus Schritt 2 ein, falls genannt (als weitere
   `pruefe_datei "..."`-Zeile), und mach sie ausführbar.

4. Prüfe die Datei mit `bash -n`.

5. Lies ~/.claude/settings.json. Existiert die Datei nicht, frag, ob du sie
   neu anlegen darfst (dann direkt mit dem Zielschema oben). Existiert sie:
   leg zuerst eine Sicherung an
   (~/.claude/settings.json.vor-maschinenraum-<heutiges Datum>), zeig mir
   den geplanten Unterschied, und füge den SessionStart-Eintrag erst nach
   meinem Ja per folgendem idempotenten Python-Schnipsel ein (nicht die
   Datei neu schreiben, keine bestehende Gruppe entfernen, keinen
   doppelten Eintrag anlegen, atomar schreiben):

   python3 - <<'PY'
   import json, os, tempfile

   pfad = os.path.expanduser("~/.claude/settings.json")
   befehl = os.path.expanduser("~/.claude/hooks/sitzungsstart.sh")

   with open(pfad) as f:
       daten = json.load(f)

   hooks = daten.setdefault("hooks", {})
   session_start = hooks.setdefault("SessionStart", [])

   schon_da = any(
       h.get("type") == "command" and h.get("command") == befehl
       for gruppe in session_start
       for h in gruppe.get("hooks", [])
   )

   if not schon_da:
       session_start.append({"hooks": [{"type": "command", "command": befehl}]})

   tmp_fd, tmp_pfad = tempfile.mkstemp(dir=os.path.dirname(pfad))
   try:
       with os.fdopen(tmp_fd, "w") as f:
           json.dump(daten, f, indent=2, ensure_ascii=False)
           f.write("\n")
       os.replace(tmp_pfad, pfad)
   except Exception:
       os.unlink(tmp_pfad)
       raise
   PY

   Prüfe danach mit
   `python3 -c "import json; json.load(open(os.path.expanduser('~/.claude/settings.json')))"`,
   dass die Datei gültiges JSON ist, und dass alle vorher vorhandenen
   Einträge noch da sind (Diff gegen die Sicherung zeigen).

6. Führe die Abnahme aus.

## Verbotsliste

- ~/.claude/settings.json nie komplett überschreiben, nur den einen
  Hook-Eintrag ergänzen (idempotent, siehe Schritt 5), alles andere bleibt
  unangetastet.
- Keine Änderung ohne vorheriges Anlegen einer Sicherung.
- Keinen anderen Hook-Typ (PreToolUse, PostToolUse, Stop) anfassen.
- Bei der Abnahme keine neue Sitzung selbst simulieren oder behaupten - nur
  der Mensch kann das auslösen.

## Was du mich fragen musst

- ob es eine zweite Laufanzeige gibt, die mitgelesen werden soll
- Erlaubnis, bevor settings.json geändert wird
- dass ich selbst eine neue Sitzung öffne, für die Abnahme

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob settings.json neu angelegt oder geändert wurde, mit Sicherungsname
- das Ergebnis des Fehlerfall-Tests (was beim Sitzungsstart erschien)
- dass die Testzeile wieder entfernt wurde
```

---

## Was jetzt anders ist

Jede neue Sitzung beginnt jetzt von selbst mit dem, was seit der letzten
Sitzung in deiner Laufanzeige neu passiert ist, du musst nicht mehr danach
fragen. Bleibt die Meldung aus, ist seither kein Job schiefgegangen - und
ein längst gezeigter alter Fehler taucht nicht wieder auf.
