#安装中文字体
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji

#安装输入法
sudo pacman -S ibus ibus-libpinyin # 这个与gnome更加般配
sudo pacman -S fcitx5-im fcitx5-rime
sudo pacman -S rime-pinyin-simp

mkdir -p ~/.config/environment.d
cat >~/.config/environment.d/fcitx5.conf <<EOF2
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
EOF2

echo $GTK_IM_MODULE
echo $QT_IM_MODULE
echo $XMODIFIERS
