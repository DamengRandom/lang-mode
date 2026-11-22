# Re-record with: vhs assets/demo.tape
Output assets/demo.gif
Set Shell zsh
Set FontSize 16
Set Width 1300
Set Height 720
Set Theme "Catppuccin Mocha"
Set TypingSpeed 35ms
Set WaitTimeout 180s

Hide
Type "setopt interactivecomments; export PS1='> ' && clear" Enter
Show

Type "# 1. Install / 安装" Enter
Type "claude plugin marketplace add ~/lang-mode" Enter
Wait
Type "claude plugin install lang-mode@lang-mode" Enter
Wait
Sleep 1s

Type "# 2. This session only / 仅本次会话" Enter
Type "claude -p '/lang-once es' < /dev/null" Enter
Wait
Sleep 1s

Type "# 3. Every session / 所有会话" Enter
Type "claude -p '/lang-memo es' < /dev/null" Enter
Wait
Type "claude -p 'What is git? One sentence.' < /dev/null" Enter
Wait
Sleep 1s
Type "claude -p '/lang-memo off' < /dev/null" Enter
Wait
Sleep 1s

Type "# 4. Uninstall / 卸载" Enter
Type "claude plugin uninstall lang-mode@lang-mode && claude plugin marketplace remove lang-mode" Enter
Wait
Sleep 3s
