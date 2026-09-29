# Einrichten lassen: Codex

**Wofür:** Ein zweiter Agent mit eigenem Guthaben, der Fleißarbeit und Bilder
übernimmt, während dein Claude das Urteil behält. Codex steckt in den
ChatGPT-Tarifen, mit unterschiedlich viel Nutzung. Für regelmäßige Arbeit
empfehle ich Plus, rund 23 € im Monat, das schließt du selbst ab.

**So benutzt du diese Datei:** Hast du noch kein passendes ChatGPT-Konto,
richte es zuerst selbst ein und prüf dabei, ob dein Tarif und sein
Nutzungsrahmen für dich reichen. Öffne dann Claude in einem beliebigen
Ordner und gib ihm den Text unterhalb der Linie.

---

```
Richte mir Codex und codex-do aus dem Maschinenraum ein.

## Ziel

Die Codex-Kommandozeile ist installiert und angemeldet. Der Befehl codex-do
liegt unter ~/.local/bin und funktioniert. Ich kann Codex ab jetzt für
Fleißarbeit und Bilder nutzen, ohne dass seine Rohausgabe mein Gespräch
zumüllt.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir `codex --version`.
2. Führe aus:
   codex-do <<'EOF'
   Antworte nur mit dem Wort "bereit".
   EOF
   Zeig mir die Ausgabe. Dort muss "bereit" stehen, dazu eine Zeile mit
   Exitcode und Protokollpfad. Keine Token-Zahl, die gibt codex-do
   absichtlich nicht aus.
3. Zeig mir `ls ~/.codex-tandem/logs/ | tail -3`, dort muss die eben
   erzeugte Protokolldatei auftauchen.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Prüfe mit `command -v codex`, ob die Codex-Kommandozeile schon
   installiert ist.
   - Fehlt sie: frag mich, ob du sie installieren darfst
     (`npm install -g @openai/codex` oder, falls Homebrew da ist,
     `brew install --cask codex`), und warte auf mein Ja.
   - Danach: führe `codex login` selbst aus. Das startet einen lokalen
     Anmeldeserver und öffnet von selbst den Anmeldedialog im Browser. Sag
     mir, dass ich dort meine Anmeldung mit meinem ChatGPT-Konto bestätigen
     muss, das ist eine Anmeldung, die nur ich abschließen kann. Verlangt
     Codex stattdessen einen manuellen Schritt im Terminal (etwa eine URL
     zum Kopieren), sag mir genau, was ich anklicken oder eingeben muss,
     statt mich raten zu lassen.

3. Prüfe, ob ~/.local/bin existiert, leg den Ordner sonst an. Frag mich
   zuerst, ob du in ~/.local/bin schreiben darfst, und zeig mir, was
   hineinkommt.

4. Kopiere ~/maschinenraum/vorlagen/codex/codex-do nach
   ~/.local/bin/codex-do und mach die Datei ausführbar
   (chmod +x). Existiert dort schon eine Datei mit diesem Namen, zeig mir
   den Unterschied und lass mich entscheiden.

5. Prüfe mit `bash -n`, dass die Datei syntaktisch sauber ist.

6. Prüfe, ob ~/.local/bin im PATH meiner Shell steht (`echo $PATH`). Fehlt
   es, sag mir genau die eine Zeile, die in meine Shell-Konfiguration muss,
   und füge sie erst nach meinem Ja ein.

7. Lege ~/.codex-tandem/ an, falls es fehlt.

8. Führe die Abnahme aus.

## Verbotsliste

- Keine vorhandene Datei unter ~/.local/bin ohne mein Ja überschreiben.
- Meinen Anmeldeschlüssel oder mein Passwort nie selbst sehen wollen oder
  abfragen, das läuft ausschließlich über den Anmeldedialog im Browser.
- Kein `codex exec` direkt aufrufen, nur über codex-do.

## Was du mich fragen musst

- ob du Codex installieren darfst
- ob du in ~/.local/bin schreiben darfst
- ob die PATH-Zeile in meine Shell-Konfiguration soll
- dass ich die Anmeldung im Browser bestätige, sobald sich der Dialog öffnet

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob Codex neu installiert wurde
- die Ausgabe des Probeaufrufs, wortwörtlich
- der Pfad der erzeugten Protokolldatei
```

---

## Was jetzt anders ist

Du hast jetzt einen zweiten Agenten mit eigenem Guthaben, den dein Claude für
Fleißarbeit einspannen kann, ohne dass dessen Rohausgabe dein Gespräch
sprengt. Was er tut, steht kurz gefasst in deiner Antwort, das volle
Protokoll liegt daneben, falls du es je brauchst.
