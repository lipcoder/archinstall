# 一个“把 AUR 包提前编译好，变成 pacman 仓库”的项目
# 如果可以走代理下载，而且电脑配置不垃圾，其实不需要这个
cat >>/etc/pacman.conf <<EOF
[aur-repo]
Server = https://rom.ie8.pub:2443/aur-repo/$arch
Server = http://fun.ie8.pub:2442/aur-repo/$arch
EOF

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

# 找包
yay -S pacseek # 使用也是命令行输入pacseek

# 网络下载工具和同步工具
sudo pacman -S wget rsync

# edge
yay -S microsoft-edge-stable

# 删除软件遗留的配置文件
sudo pacman -S lostfiles

#
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
