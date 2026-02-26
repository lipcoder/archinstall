# ===================================Golang===================================

# 官方
# go env -w GOPROXY=https://proxy.golang.org,direct
# go env -w GOSUMDB=sum.golang.org

# 中国大陆推荐：设置代理镜像，加速拉包
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOSUMDB=sum.golang.org

# 查看下载源和校验源
go env GOPROXY
go env GOSUMDB

# 将go的工具加入到path里面
echo "安装地址为-->$PATH" | tr ':' '\n' | grep -Ei '(^|/)(go|gopath|gobin)(/|$)|/go/bin'
grep -Fqx 'export PATH="$HOME/go/bin:$PATH"' ~/.bashrc 2>/dev/null || echo 'export PATH="$HOME/go/bin:$PATH"' >>~/.bashrc
# echo "$PATH" | tr ':' '\n' （查看系统全局path有什么）

# 一次性安装与更新 vscode及vim 常用的 Go 工具
pkgs=(
	"golang.org/x/tools/gopls@latest"                            # 语言服务
	"golang.org/x/tools/cmd/goimports@latest"                    # 自动导包/格式化
	"mvdan.cc/gofumpt@latest"                                    # 更严格的格式化（可选）
	"honnef.co/go/tools/cmd/staticcheck@latest"                  # 静态检查
	"github.com/golangci/golangci-lint/cmd/golangci-lint@latest" # 代码规范整套（可选）
	"github.com/go-delve/delve/cmd/dlv@latest"                   # 调试器
	"github.com/cweill/gotests/gotests@latest"                   # 生成测试
	"github.com/josharian/impl@latest"                           # 生成接口实现
	"github.com/haya14busa/goplay/cmd/goplay@latest"             # Playground 本地化（可选）
	"github.com/ramya-rao-a/go-outline@latest"                   # 大纲视图支持
	"github.com/fatih/gomodifytags@latest"                       # 结构体 tag 批量修改
	"github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest"             # 包/符号索引
)

for p in "${pkgs[@]}"; do
	echo "==> installing $p"
	if go install "$p"; then
		echo "✅ OK: $p"
	else
		echo "❌ FAIL: $p" >&2
	fi
done
