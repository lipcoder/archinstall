
sudo pacman -S bluez bluez-utils bluedevil

sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber


bluetoothctl


power on
agent on
default-agent

scan on


pair XX:XX:XX:XX:XX:XX
trust XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX

exit
