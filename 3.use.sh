# 本文件用于安装需要的文件，和配置一些软件

# 基础软件
sudo pacman -S ark kitty

# bash美化
# __git_ps1 是 Git 自带的一个函数，用来在提示符里显示当前目录的 Git 分支
sudo pacman -S git
cat >>$HOME/.bashrc <<'EOF'
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  . /usr/share/git/completion/git-prompt.sh
fi
source ~/sh/powerbash.sh
EOF
source ~/.bashrc

# 禁用密码管理器
sed -i '/^\[Wallet\]$/,/^\[/{s/^Enabled=.*/Enabled=false/}' ~/.config/kwalletrc
# vim ~/.config/kwalletrc
# [Wallet]
# Enabled=false

# 配置蓝牙
sudo pacman -S bluez bluez-utils bluedevil
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber

# vscode
yay -S visual-studio-code-bin

# yazi
sudo pacman -S yazi
cat >>"$HOME/.bashrc" <<'EOF'
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
EOF
source ~/.bashrc

# nc
sudo pacman -S openbsd-netcat
# nc ip 8080  # 测试目标主机某个端口是否开放
# nc -zv 192.168.1.10 1-1000

# 音视频处理
sudo pacman -S ffmpeg
# ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -map 0:v:0 -map 1:a:0 -shortest output.mp4 # 替换音频

# 游戏
sudo pacman -S hmcl #mc

# 找包
yay -S pacseek # 使用也是命令行输入pacseek

# 测试软件
sudo pacman -S vkmark

# 网络下载工具和同步工具
sudo pacman -S wget rsync
