# 本文件用于安装需要的文件，和配置一些软件

# 基础软件
sudo pacman -S ark kitty yay firefox gparted

# clean命令，用来多余的包
cat >>$HOME/.bashrc <<'EOF'
alias clean="sudo pacman -Qdttq | sudo pacman -Rns -"
EOF

# bash美化
# __git_ps1 是 Git 自带的一个函数，用来在提示符里显示当前目录的 Git 分支
sudo pacman -S git
cat >>$HOME/.bashrc <<'EOF'
alias gitl="git log -M --graph --color=always --pretty=format:'%Cred%h%Creset -%C(blue)%d%Creset %s%Cgreen(%cr,%an)%Creset' --abbrev-commit --date=relative --ignore-submodules"
alias gits="git status --ignore-submodules='dirty' -sb -uall"
alias gita='git add'
function gitm() {
	git commit -m "$*"
}
EOF
mkdir $HOME/sh/ && cd $HOME/sh/
curl -L -o powerbash.sh https://raw.githubusercontent.com/zw963/powerbash/master/powerbash.sh
cat >>$HOME/.bashrc <<'EOF'
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  . /usr/share/git/completion/git-prompt.sh
fi
source ~/sh/powerbash.sh
EOF
source ~/.bashrc

# 配置蓝牙
sudo pacman -S bluez bluez-utils
sudo systemctl enable --now bluetooth
# 这些是针对蓝牙连接耳机的
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber
# 这个不需要手动启动，这个是用户会话服务，一般开机会自动启动，重启就行了
systemctl --user status pipewire
systemctl --user status wireplumber
# kde蓝牙需要的前端，gnome一般都推荐安装完整桌面，所以这里不罗列需要的包了
sudo pacman -S bluedevil

# vscode
yay -S visual-studio-code-bin

# bash美化
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

# 命令行消息发送至系统通知
sudo pacman -S libnotify

mkdir -p ~/.local/share/applications
cat >> ~/.local/share/applications/command-alert.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=命令提醒
Comment=Terminal command completion notifications
Icon=utilities-terminal
Exec=/bin/true
NoDisplay=true
EOF

update-desktop-database ~/.local/share/applications 2>/dev/null

cat >> ~/bashrc <<'EOF'
# 命令行消息发送至系统通知,-t为消息关闭时间
alert() {
	local exit_code=$?
	local msg

	if [ -n "$*" ]; then
		msg="$*"
	else
		msg="$(history 1 | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//; s/[;&|[:space:]]*alert([[:space:]].*)?[[:space:]]*$//')"
		[ -z "$msg" ] && msg="上一条命令"
	fi

	if [ "$exit_code" -eq 0 ]; then
		notify-send \
			-a "命令提醒" \
			-i utilities-terminal \
			-u normal \
			-t 5000 \
			-h string:desktop-entry:command-alert \
			"命令完成" \
			"$msg 已成功完成"
	else
		notify-send \
			-a "命令提醒" \
			-i dialog-error \
			-u critical \
			-t 0 \
			-h string:desktop-entry:command-alert \
			"命令失败" \
			"$msg 失败，退出码：$exit_code"
	fi

	return "$exit_code"
}
EOF
