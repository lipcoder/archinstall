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