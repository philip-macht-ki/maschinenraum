# Karte vor Dateilesen

Dieser Ordner hat eine gepflegte Karte in `graphify-out/` (gitignored). Vor
einer Architektur- oder „Wo hängt X dran"-Frage zuerst:

```
graphify query "<Frage>" --budget 1500     # Zusammenhang
graphify explain "<Symbol>"                 # ein Knoten und seine Nachbarn
graphify path "<A>" "<B>"                   # Verbindung zweier Symbole
graphify affected "<Symbol>"                # was bricht, wenn X sich ändert
```

Erst wenn die Karte nichts hergibt, Dateien lesen oder einen breiten
Such-Subagenten starten. Fehlt `graphify-out/graph.json`, `graphify update .`
laufen lassen (AST-only, ohne Modell, wenige Sekunden bis Minuten).
