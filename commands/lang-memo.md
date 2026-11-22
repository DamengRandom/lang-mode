---
description: Always reply in a language, in every session (e.g. /lang-memo zh, /lang-memo off)
argument-hint: <language, e.g. zh | es | ja> or off
allowed-tools: Bash(bash:*)
---
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/lang-memo.sh" $ARGUMENTS`

Report the result above to the user in one short sentence. If a language was
set, write that sentence (and every later reply) in that language.
