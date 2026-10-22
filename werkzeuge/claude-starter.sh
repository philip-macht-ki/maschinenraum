#!/bin/bash
# claude-starter.sh: sorgt dafuer, dass ein Zeitplan den Befehl claude findet.
# Die Claude-App bringt Claude Code selbst mit, legt es aber nicht in den
# Suchpfad. Fehlt claude, legt dieses Skript ~/.local/bin/claude an: ein kleiner
# Starter, der bei jedem Aufruf die neueste Version aus der App startet.
# Kein Homebrew, kein npm, kein Admin-Passwort.
#
# Aufruf: bash ~/maschinenraum/werkzeuge/claude-starter.sh

set -euo pipefail

if command -v claude >/dev/null 2>&1; then
  echo "claude ist schon da: $(command -v claude)"
  exit 0
fi

mkdir -p "$HOME/.local/bin"
ZIEL="$HOME/.local/bin/claude"
cat > "$ZIEL" <<'STARTER'
#!/bin/bash
# Startet die neueste Claude-Code-Version, die die Claude-App mitbringt.
BASIS="$HOME/Library/Application Support/Claude/claude-code"
NEUESTE="$(ls "$BASIS" 2>/dev/null | sort -V | tail -1)"
BIN="$(find "$BASIS/$NEUESTE" -path '*/claude.app/Contents/MacOS/claude' -type f 2>/dev/null | head -1)"
[ -n "$BIN" ] || { echo "claude: keine Version der Claude-App gefunden unter $BASIS" >&2; exit 127; }
exec "$BIN" "$@"
STARTER
chmod +x "$ZIEL"
"$ZIEL" --version
echo "Starter angelegt: $ZIEL"
