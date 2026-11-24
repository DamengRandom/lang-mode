# lang-mode

**English** · [中文](README.zh-CN.md)

Make Claude Code reply in **your** language — just for this session, or in every session.

![demo](assets/demo.gif)

## Commands

| Command             | What it does                                                                           |
| ------------------- | -------------------------------------------------------------------------------------- |
| `/lang-once <lang>` | Reply in `<lang>` for the **current session only**. A new session goes back to normal. |
| `/lang-memo <lang>` | Reply in `<lang>` in **every new session** (saved to `~/.claude/CLAUDE.md`).           |
| `/lang-memo off`    | Remove the saved language. New sessions use the default language again.                |
| `/lang-mode:uninstall`   | Remove the saved language **and** uninstall the plugin. Restart Claude Code after.     |

`<lang>` can be an ISO code or a name: `zh` (Chinese), `es` (Spanish), `ja` (Japanese), `fr` (French), `de` (German), `ko` (Korean), `spanish`, ...
Note: Chinese is `zh`, not `cn` (`cn` is the country code for China).

Code, commands, file paths and identifiers always stay in their original form.

## Install

> **Platform: macOS only.** `/lang-memo` runs a bash script and has only been tested on macOS. Linux may work but is not supported; <b>\*\*Windows & Linux\*\*</b> are not supported yet.

Requires [Claude Code](https://claude.com/claude-code). In a terminal:

```bash
claude plugin marketplace add DamengRandom/lang-mode
claude plugin install lang-mode@lang-mode
```

Or inside Claude Code:

```
/plugin marketplace add DamengRandom/lang-mode
/plugin install lang-mode@lang-mode
```

Type `/reload-plugins` to load the newly installed lang-mode plugin (no restart needed).

Restart Claude Code, then type `/lang-once zh` or `/lang-memo es`.

## Uninstall

Easiest: type `/lang-mode:uninstall`, then restart Claude Code. It removes the saved language from `~/.claude/CLAUDE.md` and uninstalls the plugin in one step.

`/lang-mode:uninstall` only removes what lang-mode wrote. If your `CLAUDE.md` has its own language rule (e.g. "Always reply in Chinese"), Claude keeps following it.

If you installed lang-mode at project scope, the uninstall step may fail. Your saved language is still removed, and the command prints what to run by hand. Add `--scope project` to the `claude plugin uninstall` command it prints.

Manual way:

1. **First** run `/lang-memo off` if you ever used `/lang-memo`. Uninstalling removes the commands, but not the line saved in `~/.claude/CLAUDE.md`.
2. Then:

```bash
claude plugin uninstall lang-mode@lang-mode
claude plugin marketplace remove lang-mode
```

Forgot step 1? Open `~/.claude/CLAUDE.md` and delete everything between `<!-- lang-mode:start -->` and `<!-- lang-mode:end -->`.

## How it works

- `/lang-once` is a prompt that tells Claude which language to use for the rest of the conversation. Nothing is written to disk.
- `/lang-memo` runs `scripts/lang-memo.sh`, which adds (or replaces) one marked block in `~/.claude/CLAUDE.md`. Claude Code reads that file at the start of every session. `off` removes the block and leaves the rest of the file untouched.

## Full flow

```
Install:    /plugin marketplace add ... → /plugin install ... → restart
              ↓ (this step does not touch CLAUDE.md)
One-off:    /lang-once zh   → current session only, nothing written to disk
Long-term:  /lang-memo zh   → writes to CLAUDE.md (uses a temp file, deleted right after)
Switch:     /lang-memo es   → replaces the zh block with an es block
Turn off:   /lang-memo off  → removes the block from CLAUDE.md, plugin stays installed
Uninstall:  /lang-mode:uninstall → restart   (= /lang-memo off + uninstall + marketplace remove)
```

---

## Development

```bash
bash scripts/test.sh                       # self-check for lang-memo.sh
claude --plugin-dir . -p "/lang-once es"   # try without installing
vhs assets/demo.tape                       # re-record the GIF
```

License: MIT
