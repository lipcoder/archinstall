# bash美化
# __git_ps1 是 Git 自带的一个函数，用来在提示符里显示当前目录的 Git 分支
cat >>$HOME/.bashrc <<'EOF'
alias gitl="git log -M --graph --color=always --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s%Cgreen(%cr,%an)%Creset' --abbrev-commit --date=relative --ignore-submodules"
alias gits="git status --ignore-submodules='dirty' -sb -uall"
alias gita='git add'
function gitm() {
	git commit -m "$*"
}
EOF

cat >>~/.config/kitty/kitty.conf <<'EOF'
background #212121
foreground #eeeeee

cursor #eeeeee
selection_background #424242
selection_foreground #ffffff

background_opacity 1.0

# 使用 splits 布局，这样新窗口表现为真正的分屏
enabled_layouts splits

# Ctrl + Enter 新建分屏，并继承当前目录
map ctrl+enter launch --cwd=current --location=split

# Alt + 方向键切换到对应方向的分屏
map alt+left neighboring_window left
map alt+right neighboring_window right
map alt+up neighboring_window top
map alt+down neighboring_window bottom
# <<< custom kitty split keys

EOF

# 要使用的工具和字体
sudo pacman -S starship ttf-cascadia-code-nerd
mkdir -p ~/.config/kitty && echo "font_family CaskaydiaCove Nerd Font" >>~/.config/kitty/kitty.conf
grep -qxF 'eval "$(starship init bash)"' ~/.bashrc || echo 'eval "$(starship init bash)"' >>~/.bashrc

# 备份配置
[ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml ~/.config/starship.toml.bak.$(date +%s)

cat >~/.config/starship.toml <<'EOF'
"$schema" = "https://starship.rs/config-schema.json"

add_newline = true
command_timeout = 1000

format = """
[](fg:#7aa2f7)\
$os\
[](fg:#7aa2f7 bg:#89ddff)\
$username\
[](fg:#89ddff bg:#7dcfff)\
$directory\
($git_branch$git_status[](fg:#5e81ac bg:#b4befe))\
${custom.no_git_sep}\
$time\
[](fg:#b4befe)\
${custom.venv_plain}
$character"""

[os]
disabled = false
style = "fg:#1e1e2e bg:#7aa2f7 bold"
format = "[ $symbol ]($style)"

[os.symbols]
Arch = ""
Linux = ""
Ubuntu = ""
Debian = ""
Fedora = ""
Macos = ""
Windows = ""

[username]
show_always = true
style_user = "fg:#1e1e2e bg:#89ddff bold"
style_root = "fg:#1e1e2e bg:#89ddff bold"
format = "[ $user ]($style)"

[directory]
style = "fg:#1e1e2e bg:#7dcfff bold"
format = "[ $path ]($style)"
truncation_length = 2
truncation_symbol = ".../"
home_symbol = "~"

[git_branch]
style = "fg:#eceff4 bg:#5e81ac bold"
format = "[](fg:#7dcfff bg:#5e81ac)[ $branch]($style)"

[git_status]
style = "fg:#eceff4 bg:#5e81ac bold"
format = "([~$all_status$ahead_behind ]($style))"

conflicted = "="
ahead = "⇡"
behind = "⇣"
diverged = "⇕"
up_to_date = ""
untracked = "?"
stashed = "$"
modified = "!"
staged = "+"
renamed = "»"
deleted = "x"

[custom.no_git_sep]
when = 'if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then exit 1; else exit 0; fi'
command = 'printf ""'
style = "fg:#7dcfff bg:#b4befe"
format = "[$output]($style)"
shell = ["bash", "-c"]
use_stdin = false

[time]
disabled = false
time_format = "%H:%M"
style = "fg:#1e1e2e bg:#b4befe bold"
format = "[ $time ]($style)"

[custom.venv_plain]
when = 'test -n "$VIRTUAL_ENV" || test -n "$CONDA_DEFAULT_ENV"'
command = '''
if [ -n "$VIRTUAL_ENV" ]; then
  name="$(basename "$VIRTUAL_ENV")"
  case "$name" in
    .venv|venv|env)
      basename "$(dirname "$VIRTUAL_ENV")"
      ;;
    *)
      printf "%s" "$name"
      ;;
  esac
elif [ -n "$CONDA_DEFAULT_ENV" ]; then
  printf "%s" "$CONDA_DEFAULT_ENV"
fi
'''
style = "fg:#b4befe bold"
format = "[ ~ $output]($style)"
shell = ["bash", "-c"]
use_stdin = false

[character]
success_symbol = "[❯](bold #7dcfff)"
error_symbol = "[❯](bold #f7768e)"
EOF
