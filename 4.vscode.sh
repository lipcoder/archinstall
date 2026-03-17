#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r ext; do
  [ -z "$ext" ] && continue
  code --install-extension "$ext"
done < vscode-extensions.txt

echo "安装完成"

# code --list-extensions > vscode-extensions.txt
# 导出当前的插件