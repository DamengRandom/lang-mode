# lang-mode

Make Claude Code reply in **your** language — just for this session, or in every session.
让 Claude Code 用**你的**语言回答 —— 可以只在本次会话生效，也可以在所有会话中生效。

![demo](assets/demo.gif)

**[English](#english) · [中文](#中文)**

---

## English

### Commands

| Command | What it does |
|---|---|
| `/lang-once <lang>` | Reply in `<lang>` for the **current session only**. A new session goes back to normal. |
| `/lang-memo <lang>` | Reply in `<lang>` in **every new session** (saved to `~/.claude/CLAUDE.md`). |
| `/lang-memo off` | Remove the saved language. New sessions use the default language again. |

`<lang>` can be an ISO code or a name: `zh` (Chinese), `es` (Spanish), `ja` (Japanese), `fr` (French), `de` (German), `ko` (Korean), `spanish`, ...
Note: Chinese is `zh`, not `cn` (`cn` is the country code for China).

Code, commands, file paths and identifiers always stay in their original form.

### Install

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

Restart Claude Code, then type `/lang-once zh` or `/lang-memo es`.

### Uninstall

1. **First** run `/lang-memo off` if you ever used `/lang-memo`. Uninstalling removes the commands, but not the line saved in `~/.claude/CLAUDE.md`.
2. Then:

```bash
claude plugin uninstall lang-mode@lang-mode
claude plugin marketplace remove lang-mode
```

Forgot step 1? Open `~/.claude/CLAUDE.md` and delete everything between `<!-- lang-mode:start -->` and `<!-- lang-mode:end -->`.

### How it works

- `/lang-once` is a prompt that tells Claude which language to use for the rest of the conversation. Nothing is written to disk.
- `/lang-memo` runs `scripts/lang-memo.sh`, which adds (or replaces) one marked block in `~/.claude/CLAUDE.md`. Claude Code reads that file at the start of every session. `off` removes the block and leaves the rest of the file untouched.

---

## 中文

### 命令

| 命令 | 作用 |
|---|---|
| `/lang-once <语言>` | **仅本次会话**用该语言回答。开新会话后恢复默认。 |
| `/lang-memo <语言>` | **之后每个新会话**都用该语言回答（保存在 `~/.claude/CLAUDE.md`）。 |
| `/lang-memo off` | 删除保存的语言设置，新会话恢复默认语言。 |

`<语言>` 可以写语言代码或名称：`zh`（中文）、`es`（西班牙语）、`ja`（日语）、`fr`（法语）、`de`（德语）、`ko`（韩语）、`spanish` 等。
注意：中文的代码是 `zh`，不是 `cn`（`cn` 是中国的国家代码）。

代码、命令、文件路径和标识符始终保持原样，不会被翻译。

### 安装

需要先安装 [Claude Code](https://claude.com/claude-code)。在终端运行：

```bash
claude plugin marketplace add DamengRandom/lang-mode
claude plugin install lang-mode@lang-mode
```

或者在 Claude Code 里输入：

```
/plugin marketplace add DamengRandom/lang-mode
/plugin install lang-mode@lang-mode
```

重启 Claude Code 后，输入 `/lang-once zh` 或 `/lang-memo zh` 即可使用。

### 卸载

1. 如果用过 `/lang-memo`，**先**运行 `/lang-memo off`。卸载插件只会删除命令，不会删除已经写入 `~/.claude/CLAUDE.md` 的那段设置。
2. 然后运行：

```bash
claude plugin uninstall lang-mode@lang-mode
claude plugin marketplace remove lang-mode
```

忘了第 1 步？打开 `~/.claude/CLAUDE.md`，删除 `<!-- lang-mode:start -->` 和 `<!-- lang-mode:end -->` 之间的所有内容即可。

### 工作原理

- `/lang-once` 只是一段提示词，告诉 Claude 本次对话之后都用指定语言回答，不会写入任何文件。
- `/lang-memo` 会运行 `scripts/lang-memo.sh`，在 `~/.claude/CLAUDE.md` 中添加（或替换）一段带标记的设置。Claude Code 每次启动会话都会读取这个文件。`off` 只删除这段设置，文件的其他内容不受影响。

---

## Development / 开发

```bash
bash scripts/test.sh                       # self-check for lang-memo.sh / 脚本自检
claude --plugin-dir . -p "/lang-once es"   # try without installing / 不安装直接试用
vhs assets/demo.tape                       # re-record the GIF / 重新录制 GIF
```

License: MIT
