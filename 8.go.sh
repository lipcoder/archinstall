pkgs=(
  "golang.org/x/tools/gopls@latest"
  "golang.org/x/tools/cmd/goimports@latest"
  "mvdan.cc/gofumpt@latest"
  "honnef.co/go/tools/cmd/staticcheck@latest"
  "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
  "github.com/go-delve/delve/cmd/dlv@latest"
  "github.com/cweill/gotests/gotests@latest"
  "github.com/josharian/impl@latest"
  "github.com/haya14busa/goplay/cmd/goplay@latest"
  "github.com/ramya-rao-a/go-outline@latest"
  "github.com/fatih/gomodifytags@latest"
  "github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest"
)
for p in "${pkgs[@]}"; do
  echo "==> installing $p"
  go install "$p" || exit 1
done

