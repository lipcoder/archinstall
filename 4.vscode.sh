#!/usr/bin/env bash
# 导出当前插件(code --list-extensions > vscode-extensions.txt)
# 导入插件
set -euo pipefail

while IFS= read -r ext; do
	[ -z "$ext" ] && continue
	code --install-extension "$ext"
done <vscode-extensions.txt

echo "安装完成"

# 导出配置文件
# cp "$HOME/.config/Code/User/keybindings.json" .vscode/keybindings.json
# cp "$HOME/.config/Code/User/settings.json" .vscode/settings.json
# 导入配置文件
cp .vscode/settings.json "$HOME/.config/Code/User/settings.json"
cp .vscode/keybindings.json "$HOME/.config/Code/User/keybindings.json"

echo "已恢复到 $HOME/.config/Code/User/"
