#!/usr/bin/env bash
# Self-check for lang-memo.sh: set, replace, off must restore the original file byte-for-byte.
set -euo pipefail
dir="$(mktemp -d)"; export CLAUDE_CONFIG_DIR="$dir"
s="$(dirname "$0")/lang-memo.sh"
for original in $'# My rules\n\nBe nice.\n' $'no trailing newline' $'a\n\n\n' ''; do
  printf '%s' "$original" > "$dir/CLAUDE.md"
  bash "$s" zh >/dev/null
  grep -q 'language: zh' "$dir/CLAUDE.md"
  bash "$s" es >/dev/null
  [ "$(grep -c 'lang-mode:start' "$dir/CLAUDE.md")" = 1 ]   # replaced, not duplicated
  grep -q 'language: es' "$dir/CLAUDE.md"
  ! grep -q 'language: zh' "$dir/CLAUDE.md"
  bash "$s" off >/dev/null
  [ "$(cat "$dir/CLAUDE.md")" = "$(printf '%s' "$original")" ] || { echo "FAIL restore: [$original]"; exit 1; }
done
rm -f "$dir/CLAUDE.md"; bash "$s" ja >/dev/null; grep -q 'language: ja' "$dir/CLAUDE.md"  # missing file
bash "$s" | grep -q ERROR                                                                    # no arg
rm -rf "$dir"; echo "ALL PASS"
