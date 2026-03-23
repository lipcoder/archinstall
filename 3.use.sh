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
