#!/usr/bin/env bash
# Adds/removes a marked block in the user's global CLAUDE.md, which Claude Code loads in every session.
set -euo pipefail
file="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/CLAUDE.md"
start='<!-- lang-mode:start -->'
end='<!-- lang-mode:end -->'
lang="${*:-}"

if [ -z "$lang" ]; then
  echo "ERROR: no language given. Usage: /lang-memo <language> | /lang-memo off"
  exit 0
fi

mkdir -p "$(dirname "$file")"
touch "$file"

# Remove any previous block plus the one blank line we put before it.
tmp="$(mktemp)"
awk -v s="$start" -v e="$end" '
  $0 == s { blank = 0; skip = 1; next }
  skip    { if ($0 == e) skip = 0; next }
  blank   { print ""; blank = 0 }
  $0 == "" { blank = 1; next }
  { print }
  END { if (blank) print "" }
' "$file" > "$tmp"

if [ "$lang" = "off" ]; then
  cat "$tmp" > "$file"; rm -f "$tmp"
  echo "OK: lang-mode removed from $file. Claude will use its default language in new sessions."
  exit 0
fi

{
  cat "$tmp"
  printf '\n%s\n' "$start"
  printf '## Reply language (lang-mode)\n\n'
  printf 'Always reply to the user in this language: %s (interpret ISO codes such as zh, es, ja).\n' "$lang"
  printf 'Keep code, commands, file paths, identifiers and UI labels in their original form.\n'
  printf '%s\n' "$end"
} > "$file"
rm -f "$tmp"
echo "OK: saved to $file. Every new session will reply in: $lang"
