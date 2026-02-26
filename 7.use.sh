
sudo pacman -S ark yazi kitty

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