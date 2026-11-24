# lang-mode

[English](README.md) · **中文**

让 Claude Code 用**你的**语言回答 —— 可以只在本次会话生效，也可以在所有会话中生效。

![demo](assets/demo.gif)

## 命令

| 命令                | 作用                                                               |
| ------------------- | ------------------------------------------------------------------ |
| `/lang-once <语言>` | **仅本次会话**用该语言回答。开新会话后恢复默认。                   |
| `/lang-memo <语言>` | **之后每个新会话**都用该语言回答（保存在 `~/.claude/CLAUDE.md`）。 |
| `/lang-memo off`    | 删除保存的语言设置，新会话恢复默认语言。                           |
| `/lang-mode:uninstall`   | 删除保存的语言设置，**并且**卸载插件。完成后需重启 Claude Code。   |

`<语言>` 可以写语言代码或名称：`zh`（中文）、`es`（西班牙语）、`ja`（日语）、`fr`（法语）、`de`（德语）、`ko`（韩语）、`spanish` 等。
注意：中文的代码是 `zh`，不是 `cn`（`cn` 是中国的国家代码）。

代码、命令、文件路径和标识符始终保持原样，不会被翻译。

## 安装

> **平台：仅支持 macOS。** `/lang-memo` 依赖 bash 脚本，只在 macOS 上测试过。Linux 可能可以运行但不提供支持；不支持 Windows。

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

输入 `/reload-plugins` 即可加载刚安装的 lang-mode 插件（无需重启）。

重启 Claude Code 后，输入 `/lang-once zh` 或 `/lang-memo zh` 即可使用。

## 卸载

最简单的方法：输入 `/lang-mode:uninstall`，然后重启 Claude Code。它会一步完成两件事：删除 `~/.claude/CLAUDE.md` 里保存的语言设置，并卸载插件。

`/lang-mode:uninstall` 只删除 lang-mode 自己写入的内容。如果你的 `CLAUDE.md` 里还有你自己写的语言规则（比如"总是用中文回复"），Claude 会继续遵守。

如果你是在项目范围（project scope）安装的 lang-mode，卸载插件这一步可能会失败。保存的语言设置仍会被删除，命令会打印出需要手动运行的命令。在它打印的 `claude plugin uninstall` 命令后面加上 `--scope project` 即可。

手动方法：

1. 如果用过 `/lang-memo`，**先**运行 `/lang-memo off`。卸载插件只会删除命令，不会删除已经写入 `~/.claude/CLAUDE.md` 的那段设置。
2. 然后运行：

```bash
claude plugin uninstall lang-mode@lang-mode
claude plugin marketplace remove lang-mode
```

忘了第 1 步？打开 `~/.claude/CLAUDE.md`，删除 `<!-- lang-mode:start -->` 和 `<!-- lang-mode:end -->` 之间的所有内容即可。

## 工作原理

- `/lang-once` 只是一段提示词，告诉 Claude 本次对话之后都用指定语言回答，不会写入任何文件。
- `/lang-memo` 会运行 `scripts/lang-memo.sh`，在 `~/.claude/CLAUDE.md` 中添加（或替换）一段带标记的设置。Claude Code 每次启动会话都会读取这个文件。`off` 只删除这段设置，文件的其他内容不受影响。

## 完整流程

```
安装：    /plugin marketplace add ... → /plugin install ... → 重启
            ↓（这一步不碰 CLAUDE.md）
临时使用：/lang-once zh   → 只对本次会话生效，不写文件
长期使用：/lang-memo zh   → 写入 CLAUDE.md（过程中用 tmp，用完即删）
换语言：  /lang-memo es   → 用 es 块替换 zh 块
停用：    /lang-memo off  → 从 CLAUDE.md 删掉语言块，插件仍在
卸载：    /lang-mode:uninstall → 重启   （= /lang-memo off + uninstall + marketplace remove）
```

---

## 开发

```bash
bash scripts/test.sh                       # 脚本自检
claude --plugin-dir . -p "/lang-once es"   # 不安装直接试用
vhs assets/demo.tape                       # 重新录制 GIF
```

License: MIT
