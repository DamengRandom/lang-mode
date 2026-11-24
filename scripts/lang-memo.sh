#!/usr/bin/env bash
# Adds/removes a marked block in the user's global CLAUDE.md, which Claude Code loads in every session.
set -euo pipefail
file="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/CLAUDE.md"
start='<!-- lang-mode:start -->'
end='<!-- lang-mode:end -->'
lang="${*:-}"
lang="${lang#"${lang%%[![:space:]]*}"}"; lang="${lang%"${lang##*[![:space:]]}"}"  # trim

# Case-insensitive "off", so /lang-memo OFF turns it off instead of saving "OFF" as a language.
[ "$(printf '%s' "$lang" | LC_ALL=C tr 'A-Z' 'a-z')" = off ] && lang=off

if [ -z "$lang" ]; then
  echo "ERROR: no language given. Usage: /lang-memo <language> | /lang-memo off"
  exit 0
fi

# Whatever we accept is written into CLAUDE.md and loaded every session, so allow
# only ASCII letters, digits, _, space, hyphen and non-ASCII bytes (e.g. 中文, zh_CN, es-419);
# no newlines, quotes, <>, $. The trailing "." survives $(...), which would otherwise drop a leftover newline.
# The second check requires at least one letter or non-ASCII byte, so "   " or "---" is rejected.
if [ "$(printf '%s.' "$lang" | LC_ALL=C tr -d 'A-Za-z0-9_ \200-\377-')" != . ] ||
   [ -z "$(printf '%s' "$lang" | LC_ALL=C tr -d '\000-\100\133-\140\173-\177')" ] ||
   [ "${#lang}" -gt 40 ]; then
  echo "ERROR: invalid language \"$lang\". Use a name or code like zh, es, french."
  exit 0
fi

mkdir -p "$(dirname "$file")"
touch "$file"

# Remove any previous block plus the one blank line we put before it.
tmp="$(mktemp)"
rc=0
awk -v s="$start" -v e="$end" '
  $0 == s { blank = 0; skip = 1; next }
  skip    { if ($0 == e) skip = 0; next }
  blank   { print ""; blank = 0 }
  $0 == "" { blank = 1; next }
  { print }
  END { if (skip) exit 3; if (blank) print "" }
' "$file" > "$tmp" || rc=$?
if [ "$rc" -ne 0 ]; then
  rm -f "$tmp"
  if [ "$rc" -eq 3 ]; then
    # Start marker without a matching end: dropping lines to EOF would delete user content.
    echo "ERROR: $file has '$start' without a matching '$end'. Nothing changed; fix the markers by hand."
  else
    echo "ERROR: could not read $file or write a temp file (awk exit $rc). Nothing changed."
  fi
  exit 0
fi

if [ "$lang" = "off" ]; then
  cat "$tmp" > "$file" || { rm -f "$tmp"; echo "ERROR: could not write $file; it may be incomplete. Check it by hand."; exit 0; }
  rm -f "$tmp"
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
} > "$file" || { rm -f "$tmp"; echo "ERROR: could not write $file; it may be incomplete. Check it by hand."; exit 0; }  # bash 3.2: a failed redirect doesn't trip set -e
rm -f "$tmp"
echo "OK: saved to $file. Every new session will reply in: $lang"
