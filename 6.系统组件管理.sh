
# 禁用密码管理器
sed -i '/^\[Wallet\]$/,/^\[/{s/^Enabled=.*/Enabled=false/}' ~/.config/kwalletrc
# vim ~/.config/kwalletrc
# [Wallet]
# Enabled=false

# 配置蓝牙
sudo pacman -S bluez bluez-utils bluedevil
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber