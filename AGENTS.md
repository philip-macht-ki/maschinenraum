# Für Codex

Vor jeder Einrichtung oder Änderung zuerst `bash werkzeuge/aktualisieren.sh` ausführen; es holt die neueste Vorlage und bewahrt deine Einstellungen und Inhalte.

Dieser Werkzeugkasten ist für Claude geschrieben. Die Baupläne unter `einrichten/` führst du
genauso aus; wo dort „Claude“ steht, bist du gemeint.

Was bei dir anders ist:

- Orte: `~/.claude/CLAUDE.md` ist bei dir `~/.codex/AGENTS.md`, `~/.claude/skills/` ist
  `~/.codex/skills/`, Hooks stehen in `~/.codex/hooks.json`. Ein Helfer aus `~/.claude/agents/`
  wird bei dir ein Skill oder Unteragent mit demselben Inhalt.
- `claude -p` in Skripten ist bei dir `codex exec` mit `--sandbox read-only --ephemeral
  --ignore-user-config --ignore-rules`.
- Die Rollen sind umgedreht: Du bist der Hauptagent. `einrichten/mr2-codex.md` richtet Codex als
  zweiten Agenten ein; bei dir entfällt das. Ein zweiter Agent wäre Claude Code, ein lokales
  Modell oder OpenRouter, und nur, wenn der Mensch das will. Frag ihn.
- Fehlt dir ein Gegenstück (etwa ein Hook-Ereignis), sag es ehrlich, statt etwas nachzubauen,
  das nur so aussieht.
