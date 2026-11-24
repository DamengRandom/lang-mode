#!/usr/bin/env bash
# Removes the saved language from CLAUDE.md, then uninstalls the plugin and its marketplace.
set -euo pipefail
out="$(bash "$(dirname "$0")/lang-memo.sh" off)"
echo "$out"

# Only uninstall once CLAUDE.md is clean; afterwards /lang-memo off no longer exists to fix it.
case "$out" in
  OK:*) ;;
  *) echo "ERROR: lang-mode was NOT uninstalled. Fix the problem above, then run /lang-mode:uninstall again."; exit 0 ;;
esac

if claude plugin uninstall lang-mode@lang-mode && claude plugin marketplace remove lang-mode; then
  echo "OK: lang-mode uninstalled. Restart Claude Code to finish."
else
  echo "ERROR: CLAUDE.md is clean, but uninstall failed. Run by hand: claude plugin uninstall lang-mode@lang-mode && claude plugin marketplace remove lang-mode"
fi
