
sudo pacman -S ffmpeg

ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -map 0:v:0 -map 1:a:0 -shortest output.mp4 
# 替换音频
