# Modelle und Kosten

Vertrauliches oder Privates bleibt auf dem eigenen Rechner: ein lokales
Modell (Ollama), sofern eines eingerichtet ist. Nichts Vertrauliches geht an
eine bezahlte Schnittstelle.

Bezahlte APIs (OpenRouter oder aehnliche) nur mit einer vorher gesetzten,
positiven Kostenobergrenze fuer den einzelnen Aufruf, und mit Rueckfrage
davor, wenn keine Obergrenze im Auftrag steht. Ein falsch geformter Aufruf
kann trotzdem einen bezahlten Auftrag ausloesen und Dienste quittieren
Fehler oft mit Erfolg (HTTP 200) und verwerfen oder erzeugen still das
Falsche, deshalb: Schema oder Verhalten erst ueber einen bewussten
Fehlerfall pruefen (ein absichtlich falsches Feld), dann den echten Aufruf
machen, und das Ergebnis am Ziel selbst nachsehen, nie nur am Rueckgabewert.

Schluessel tippt der Mensch selbst ein, nie in den Chat, nie in eine Datei,
die ins Repo geht. Ablage im Schluesselbund
(`security add-generic-password -s <dienst> -a "$USER" -w`, fragt
interaktiv nach dem Wert), Zugriff nur ueber ein Werkzeug, das den Wert
direkt an ein Programm weiterreicht und nie in den Chat liest.

Modellwahl auch bei bezahlten Schnittstellen: das kleinste Modell, das die
Aufgabe zuverlaessig loest, ist nicht automatisch das billigste in der
Summe, ein zu kleines Modell, das falsch entscheidet, kostet an anderer
Stelle mehr als der Preisunterschied zum naechstgroesseren einspart.
