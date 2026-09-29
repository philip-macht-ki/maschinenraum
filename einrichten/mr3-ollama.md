# Einrichten lassen: ein Modell auf deinem Mac (freiwillig)

**Wofür:** Ein Modell, das ganz auf deinem Rechner läuft. Kostenlos, offline,
nichts verlässt deinen Mac. Passend für Vertrauliches, nicht für Aufgaben,
die gutes Deutsch oder ein feines Urteil brauchen.

**So benutzt du diese Datei:** Nur sinnvoll ab ungefähr 16 GB Arbeitsspeicher.
Öffne Claude in einem beliebigen Ordner und gib ihm den Text unterhalb der
Linie.

---

```
Richte mir ein lokales Modell mit Ollama ein.

## Ziel

Ollama läuft auf meinem Mac, mit einem Modell, das zu meinem Arbeitsspeicher
passt. Ich kann eine deutsche Frage stellen und bekomme eine Antwort, ohne
dass sie meinen Rechner verlässt.

## Abnahme

Zum Schluss führst du sie wirklich aus, du behauptest sie nicht:

1. Zeig mir `ollama list`.
2. Führe aus: `ollama run <modell> "Nenne drei deutsche Städte an einem
   Fluss."` und zeig mir die Antwort.
3. Zeig mir, dass die Antwort auf Deutsch ist und die Frage trifft.

## Schritte

1. Ermittle meinen Arbeitsspeicher mit `sysctl hw.memsize` und rechne in GB
   um.

2. Prüfe mit `command -v ollama`, ob Ollama installiert ist.
   - Fehlt es: frag mich, ob du es mit Homebrew installieren darfst
     (`brew install ollama`), und ob der Dienst automatisch starten soll
     (`brew services start ollama`).

3. Schlag mir anhand meines Arbeitsspeichers ein Modell vor:
   - 8 GB: ein sehr kleines Modell (2-3 Milliarden Parameter)
   - 16 GB: ein Modell um 7-8 Milliarden Parameter
   - 32 GB: ein Modell um 14 Milliarden Parameter
   - 64 GB und mehr: größere Modelle möglich, aber auch dort ist mehr nicht
     automatisch besser für unsere Zwecke
   Frag mich, ob der Vorschlag passt, dann `ollama pull <modell>`.

4. Führe die Abnahme aus.

## Verbotsliste

- Kein Modell laden, das größer ist als sinnvoll für meinen Arbeitsspeicher.
- Keine Cloud-Version von Ollama einrichten, nur die lokale.

## Was du mich fragen musst

- ob Homebrew/Ollama installiert werden darf
- ob der vorgeschlagene Modellname passt

Rate nichts. Wo du unsicher bist, frag.

## Abschlussbericht

Kurz:
- Arbeitsspeicher und gewähltes Modell
- die Testantwort, wortwörtlich
```

---

## Was jetzt anders ist

Du hast ein Modell, das ganz auf deinem Rechner arbeitet. Für Vertrauliches
ist das die richtige Wahl, für alles andere bleibt dein Claude-Abo die
bessere.
