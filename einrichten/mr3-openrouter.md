# Einrichten lassen: OpenRouter, ein Schlüssel, viele Modelle

**Wofür:** Für Aufgaben, die dein lokales Modell nicht schafft, aber die
sich nicht lohnen, komplett über dein Claude-Abo zu laufen, gibt es eine
Schnittstelle zu vielen Modellen verschiedener Anbieter, mit Kosten je
Aufruf.

**So benutzt du diese Datei:** Konto und Ausgabenlimit legst du selbst an
(openrouter.ai, im Kontobereich einen Schlüssel erzeugen und dort ein
Guthabenlimit setzen). Erst danach diese Datei benutzen. Öffne Claude in
einem Projektordner und gib ihm den Text unterhalb der Linie.

---

```
Richte mir OpenRouter aus ~/maschinenraum ein.

## Ziel

Mein OpenRouter-Schlüssel liegt sicher im Schlüsselbund, nie im Chat. Ein
Probeaufruf zeigt mir eine Antwort und die tatsächlichen Kosten dieses einen
Aufrufs.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir `security find-generic-password -s openrouter -a "$USER"` OHNE
   das Flag -w, nur um zu zeigen, dass ein Eintrag existiert, nie den Wert.
2. Führe aus: `bash ~/maschinenraum/werkzeuge/openrouter-probe.sh`
3. Zeig mir Antwort und Kosten aus der Ausgabe.

## Schritte

1. git -C ~/maschinenraum pull --ff-only

2. Frag mich, ob ich den Schlüssel schon im Schlüsselbund abgelegt habe.
   - Wenn nein: öffne mir die Schlüsselbundverwaltung
     (`open -a "Schlüsselbundverwaltung"`, ggf. `open -a "Keychain Access"`).
     Sag mir genau, was ich dort selbst eintragen muss: ein neues
     Passwortobjekt mit Dienstname "openrouter", Konto meinen
     Benutzernamen (den Wert von $USER, den du mir nennst) und den
     Schlüssel selbst als Passwort. Ich tippe den Schlüssel nur dort ein,
     nie im Terminal und nie im Chat. Warte, bis ich sage, dass ich fertig
     bin. Führe `security add-generic-password ... -w` NIE selbst mit
     einem Wert aus.

3. Führe werkzeuge/openrouter-probe.sh aus. Schlägt es fehl, lies die
   Fehlermeldung vor und schlag KEINE Abkürzung vor, die den Schlüssel im
   Klartext zeigen würde.

4. Führe die Abnahme aus.

## Verbotsliste

- Den Schlüssel niemals selbst eintippen, lesen oder in den Chat holen.
- security ... -w niemals selbst mit einem Wert ausführen.
- Kein zweites Modell ausprobieren, ohne dass ich sage, dass die Kosten des
  ersten Aufrufs für mich in Ordnung waren.

## Was du mich fragen musst

- ob der Schlüssel schon im Schlüsselbund liegt
- ob ich mit den gezeigten Kosten einverstanden bin, bevor ein zweiter
  Aufruf folgt

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- ob der Schlüssel neu angelegt wurde (nie der Wert)
- Antwort und Kosten des Probeaufrufs
```

---

## Was jetzt anders ist

Du hast Zugang zu vielen verschiedenen Modellen über einen einzigen
Schlüssel, mit einer Obergrenze, die du selbst gesetzt hast, und siehst bei
jedem Aufruf, was er tatsächlich gekostet hat.
