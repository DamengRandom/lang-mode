#!/usr/bin/env bash
# Removes the saved language from CLAUDE.md, then uninstalls the plugin and its marketplace.
set -euo pipefail
# `|| true`: if lang-memo.sh itself crashes, fall through to the NOT-uninstalled message below.
out="$(bash "$(dirname "$0")/lang-memo.sh" off 2>&1)" || true
echo "$out"

# Only uninstall once CLAUDE.md is clean; afterwards /lang-memo off no longer exists to fix it.
case "$out" in
  OK:*) ;;
  *) echo "ERROR: lang-mode was NOT uninstalled. Fix the problem above, then run /lang-mode:uninstall again."; exit 0 ;;
esac

# Two separate steps, so the hand-run hint names only what is still left to do.
if ! claude plugin uninstall lang-mode@lang-mode; then
  echo "ERROR: CLAUDE.md is clean, but uninstall failed. Run by hand: claude plugin uninstall lang-mode@lang-mode, then: claude plugin marketplace remove lang-mode"
  exit 0
fi
if ! claude plugin marketplace remove lang-mode; then
  echo "ERROR: plugin uninstalled, but removing the marketplace failed. Run by hand: claude plugin marketplace remove lang-mode"
  exit 0
fi
echo "OK: lang-mode uninstalled. Restart Claude Code to finish."
