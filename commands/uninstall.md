---
description: Remove the saved language and uninstall lang-mode (restart Claude Code afterwards)
disable-model-invocation: true
allowed-tools: Bash(bash:*)
---
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/lang-uninstall.sh"`

Report the result above to the user in one short sentence.
