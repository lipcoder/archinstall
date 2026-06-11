#!/usr/bin/env bash

# 跨平台 Go 开发环境配置脚本
# 支持：Linux + bash，macOS + zsh
# 功能：
# 1. 运行时检测当前系统
# 2. Linux 写入 ~/.bashrc，macOS 写入 ~/.zshrc
# 3. 如果 PATH 中没有 Go 工具目录，则加入 PATH
# 4. 检查 go version；如果 Go 不可用则退出，不自动安装 Go
# 5. 配置 GOPROXY / GOSUMDB
# 6. 安装 / 更新 VS Code、Vim 常用 Go 工具

set -u

info() {
  echo "==> $*"
}

warn() {
  echo "WARN: $*" >&2
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

path_has_dir() {
  case ":$PATH:" in
    *":$1:"*) return 0 ;;
    *) return 1 ;;
  esac
}

add_path_to_current_shell() {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi

  if path_has_dir "$dir"; then
    info "当前 PATH 已包含：$dir"
  else
    export PATH="$dir:$PATH"
    info "已加入当前运行环境 PATH：$dir"
  fi
}

add_path_to_rc_file() {
  local rc_file="$1"
  local path_line="$2"
  local path_text="$3"

  touch "$rc_file"

  if grep -Fq '$HOME/go/bin' "$rc_file" 2>/dev/null || grep -Fq "$path_text" "$rc_file" 2>/dev/null; then
    info "Go 工具 PATH 已存在于：$rc_file"
  else
    {
      echo ""
      echo "# Go tools"
      echo "$path_line"
    } >> "$rc_file"
    info "已写入 Go 工具 PATH 到：$rc_file"
  fi
}

info "检测当前系统"

case "$(uname -s)" in
  Linux*)
    OS_NAME="Linux"
    REQUIRED_SHELL="bash"
    RC_FILE="$HOME/.bashrc"
    SOURCE_HINT="source ~/.bashrc"
    ;;
  Darwin*)
    OS_NAME="macOS"
    REQUIRED_SHELL="zsh"
    RC_FILE="$HOME/.zshrc"
    SOURCE_HINT="source ~/.zshrc"
    ;;
  *)
    fail "当前系统暂不支持：$(uname -s)。只支持 Linux 和 macOS。"
    ;;
esac

info "当前系统：$OS_NAME"
info "将使用 shell 配置文件：$RC_FILE"

if ! command -v "$REQUIRED_SHELL" >/dev/null 2>&1; then
  fail "$OS_NAME 需要检测到 $REQUIRED_SHELL，但当前环境找不到 $REQUIRED_SHELL。"
fi

info "检测 Go 工具 PATH"

GO_TOOLS_DIR="$HOME/go/bin"
GO_TOOLS_PATH_LINE='export PATH="$HOME/go/bin:$PATH"'

add_path_to_current_shell "$GO_TOOLS_DIR"
add_path_to_rc_file "$RC_FILE" "$GO_TOOLS_PATH_LINE" "$GO_TOOLS_DIR"

info "检查 Go 是否可用"

if ! command -v go >/dev/null 2>&1; then
  fail "未找到 go 命令。请先安装 Go，并确保 go 命令在 PATH 中，然后重新运行本脚本。"
fi

if ! GO_VERSION_OUTPUT="$(go version 2>/dev/null)"; then
  fail "无法执行 go version。请检查 Go 安装是否正常。"
fi

echo "当前 Go 版本：$GO_VERSION_OUTPUT"

info "配置 Go 下载源"

# 官方源：
# go env -w GOPROXY=https://proxy.golang.org,direct
# go env -w GOSUMDB=sum.golang.org

# 中国大陆推荐：设置代理镜像，加速拉包
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOSUMDB=sum.golang.org

echo "当前 GOPROXY：$(go env GOPROXY)"
echo "当前 GOSUMDB：$(go env GOSUMDB)"

# 如果用户自定义了 GOPATH/GOBIN，这里额外提示真实安装目录；默认通常就是 $HOME/go/bin。
GOBIN_VALUE="$(go env GOBIN)"
if [ -n "$GOBIN_VALUE" ]; then
  REAL_GO_TOOLS_DIR="$GOBIN_VALUE"
else
  REAL_GO_TOOLS_DIR="$(go env GOPATH)/bin"
fi

if [ "$REAL_GO_TOOLS_DIR" != "$GO_TOOLS_DIR" ]; then
  warn "当前 Go 工具实际安装目录是：$REAL_GO_TOOLS_DIR"
  warn "你当前配置写入的是默认目录：$GO_TOOLS_DIR"
  warn "如果你长期使用自定义 GOPATH/GOBIN，可以手动把实际安装目录加入 $RC_FILE。"
fi

echo "Go 工具 PATH：$GO_TOOLS_DIR"

info "开始安装 / 更新 Go 常用工具"

pkgs=(
  "golang.org/x/tools/gopls@latest"                            # 语言服务
  "golang.org/x/tools/cmd/goimports@latest"                    # 自动导包 / 格式化
  "mvdan.cc/gofumpt@latest"                                    # 更严格的格式化
  "honnef.co/go/tools/cmd/staticcheck@latest"                  # 静态检查
  "github.com/golangci/golangci-lint/cmd/golangci-lint@latest" # 代码规范整套
  "github.com/go-delve/delve/cmd/dlv@latest"                   # 调试器
  "github.com/cweill/gotests/gotests@latest"                   # 生成测试
  "github.com/josharian/impl@latest"                           # 生成接口实现
  "github.com/haya14busa/goplay/cmd/goplay@latest"             # Playground 本地化
  "github.com/ramya-rao-a/go-outline@latest"                   # 大纲视图支持
  "github.com/fatih/gomodifytags@latest"                       # 结构体 tag 批量修改
  "github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest"             # 包 / 符号索引
)

for p in "${pkgs[@]}"; do
  echo ""
  echo "==> installing $p"

  if go install "$p"; then
    echo "OK: $p"
  else
    echo "FAIL: $p" >&2
  fi
done

info "检查安装结果"

bins=(
  gopls
  goimports
  gofumpt
  staticcheck
  golangci-lint
  dlv
  gotests
  impl
  goplay
  go-outline
  gomodifytags
  gopkgs
)

for bin in "${bins[@]}"; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "OK: $bin -> $(command -v "$bin")"
  else
    echo "MISSING: $bin"
  fi
done

echo ""
echo "完成。"
echo "如果终端、VS Code 或 Vim 仍然找不到 Go 工具，请重启它们。"
echo "也可以手动执行："
echo "  $SOURCE_HINT"
