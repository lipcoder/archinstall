#!/bin/bash

# 安装方式：

# curl https://gitlab.com/zw963/arch_linux_init/-/raw/master/1_init.sh |bash

# 另一种更好的安装方式 (这种方式不占用 stdin, 即，你可以有条件的选择 y/n)

# bash <(curl https://gitlab.com/zw963/arch_linux_init/-/raw/master/1_init.sh)

loadkeys us # 确保设定键盘为 US 布局.

# - fdisk -l 检查所有分区
# - cfdisk /dev/sda, 操作该分区
# - mkfs.ext4 /dev/sda1 格式化该分区。
# - e2label /dev/sda1 Arch 设定一个 label
# - mkswap /dev/sda2 建立 swap 分区。
# - mount /dev/sda1 /mnt 加载该分区

# 确保可以正确显示当前的网卡，否则可能续需要 ip link set dev wls1 up 来启动这个 interface
# 如果提示 operation not possible due to RF-kill, 首先运行 rfkill unblock all
ip link

# 如果使用了 wifi, 启动 iwctl, 然后根据补全，键入下面的命令： station TABwlan0 connect TABwifi

# 确保系统时间是准确的, 一定确保同步, 否则会造成签名错误.
timedatectl set-ntp true

# Windows 认为硬件时间是当地时间，而 Linux 认为硬件时间是 UTC+0 标准时间，这就很尴尬了。
timedatectl set-local-rtc true  # 让 Linux 认为硬件时间是当地时间。

# 设定上海交大源为首选源, 速度更快
# sed -i '1iServer = http://ftp.sjtu.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
# 如果是北方网通, 清华源更快
sed -i '1iServer = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist

# wol 是 wake on line 工具
pacstrap /mnt base base-devel \
         cmake arch-install-scripts nano vim curl wget \
         rsync net-tools iwd inetutils bind

swap_partition=$(sudo blkid |grep swap |cut -d: -f1)
[ "$swap_partition" ] && swapon "$swap_partition"

genfstab -U /mnt >> /mnt/etc/fstab
# genfstab -U /home >> /mnt/etc/fstab
# sed -i 's#/#/home#' /mnt/etc/fstab

# 切换到目标 root
arch-chroot /mnt /bin/bash

set -xeu

useradd -m zw963
echo 'zw963 ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# 然后需要调整当前系统显示时间为正确时间/时区，再将系统显示时间写入 RTC （RTC 就是 BIOS 时间)
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && hwclock -w

function add_config () {
    pattern="$1"
    cat "$2" |grep "^${pattern}" || echo "$pattern" >> "$2"
}

# 开启需要的 locale
add_config 'en_US.UTF-8 UTF-8' /etc/locale.gen
add_config 'zh_CN.UTF-8 UTF-8' /etc/locale.gen
add_config 'zh_TW.UTF-8 UTF-8' /etc/locale.gen

locale-gen

echo 'LANG=en_US.UTF-8' > /etc/locale.conf

echo 'zbook' > /etc/hostname

echo '127.0.0.1 localhost' >> /etc/hosts
echo '127.0.0.1 zbook' >> /etc/hosts

function pacman () {
    command pacman --noconfirm "$@"
}

function yay () {
    command yay --noconfirm "$@";
}

cat <<'HEREDOC' >> /etc/pacman.conf
[archlinuxcn]
# SigLevel = Optional TrustAll
Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch
HEREDOC
sed -i 's#\#\[multilib\]#[multilib]\nInclude = /etc/pacman.d/mirrorlist#' /etc/pacman.conf

pacman -Sy
pacman -Fy

# must update this first, otherwise, may install failed due required key missing from keyring.
# sudo pacman-key --lsign-key "farseerfc@archlinux.org"
pacman -S archlinuxcn-keyring pacman-contrib

pacman -S yay # install git too.

pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

cat <<'HEREDOC' >> /etc/pacman.conf
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
HEREDOC

# 如果没有安装 X, 为了重启后可以连接 wifi, 需要安装 iwd, dhcpcd.
# 但是如果安装了 gnome, 安装了 network-manager(替代iwd), 则只需要 systemd-networkd(替代 dhcpcd) 就够了。
# pacman -S iwd
# systemctl enable iwd

if grep /proc/cpuinfo -qs -e 'GenuineIntel'; then
    pacman -S intel-ucode
elif grep /proc/cpuinfo -qs -e 'AuthenticAMD'; then
    pacman -S amd-ucode
fi

# 注意：内核不可以用 pacstrap 安装, 因为那种模式下，post hooks 无法正确执行.
pacman -S linux linux-headers linux-firmware linux-xanmod linux-xanmod-headers mkinitcpio
# pacman -S linux-lts linux-lts-headers

# firefox/emacs 依赖这个字体，手动安装避免选择其他候选者。
# qt5 被很多程序使用，例如：bc5
pacman -S ttf-dejavu gnome konsole qt5 dkms firefox networkmanager network-manager-applet \
       bluez-utils btrfs-progs noto-fonts-emoji jack2 qt6-multimedia-ffmpeg ntfs-3g

# pacman -S fcitx-im fcitx-sunpinyin fcitx-configtool
pacman -S fcitx5-chinese-addons fcitx5-gtk fcitx5-pinyin-zhwiki fcitx5-configtool gnome-shell-extension-kimpanel-git wqy-microhei

# systemd 属于 base 的一部分。
systemctl enable systemd-networkd systemd-timesyncd NetworkManager gdm bluetooth

# wheel 看 journalctl 日志
# input xremap 支持
# lp 对于连接蓝牙设备，这是必须的。
usermod -a -G audio,lp,input,wheel zw963

# bash-completion 不知道怎么用，等会用了再装。
# pacman -S bash-completion

pacman -S man-db man-pages man-pages-zh_cn

pacman -S exfat-utils

# qemu-user 里面有个 qemu-aarm64, 可以用来测试运行 arm64 应用程序
pacman -S tree lsof git-filter-repo clang qemu-user gnu-netcat iftop inotify-tools time

# yay -S getmail6

# gptfdisk used by refind
# 安装 refind 会安装 dosfstools，ventoy 创建启动盘，会用到 mkfs.vfat, 也属于 dosfstools，
# refind 也使用 gptfdisk 来更新 EFI 分区。
pacman -S gptfdisk refind

# systemctl enable ntpdate
pacman -S cronie && systemctl enable cronie
pacman -S at && systemctl enable atd

pacman -S acpid && systemctl enable acpid

# 安装 mesa 的时候会安装 lm_sensors
# inxi -F 查看硬件信息
# pacman -S sysstat dateutils inxi

# pavucontrol is seem like not necessory.
# alsa-utils 没有安装，当安装 gnome 之后，似乎也有声音, 可能是使用最新的 pipewire
# pacman -S alsa-utils
# 将当前用户加入 audio 分组.
# sudo gpasswd -a zw963 audio

# 记得手动开启 systemctl enable btrbk.timer
pacman -S bcachefs-tools btrbk mbuffer compsize
# pacman -S snapper timeshift

# 如果安装 gnome 的时候，选择 pipewire-jack，这些被 gnome 安装。
# pacman -S wireplumber pipewire-audio pipewire-alsa pipewire-jack pipewire-pulse

pacman -S lib32-pipewire alsa-utils

# bluez bluez-libs included in gnome
#  pulseaudio-bluetooth 蓝牙耳机配对必须?
# sudo gpasswd -a zw963 lp # 对于连接蓝牙设备，这是必须的。

pacman -S gnome-tweaks gnome-usage dconf-editor gparted fsearch gnome-shell-extension-appindicator \
       geckodriver flameshot satty copyq upx locate
pacman -R epiphany

# 现在 chromium 名字换成了 ungoogled-chromium, 包含了 chromium 和 chromedriver.
pacman -S ungoogled-chromium

# 需要浏览器插件来配合，直接在浏览器安装插件。
pacman -S gnome-browser-connector

# 这两个是作为 dav 服务器的， 另一个主机可以方便的通过 dav 协议，dav://mingfan:8080 来访问文件。
# 注意，默认服务名用户级别的服务，名称是 gnome-user-share-webdav, 在每一次息屏再亮屏后，端口号会变化.
pacman rclone gvfs-dnssd

pacman -S python-pip

# xdg-desktop-portable is need for flameshot, obs etc.
# it will install xdg-desktop-portal-gnome and xdg-desktop-portal-gtk too.
# xdg-utils use xdg-open command, needed by chrome browser.

# pacman -S xdg-desktop-portal xdg-utils # 这两个安装 qt 和 gnome 的时候，会被自动安装。

# poppler-data needed for okular pdf show chinese chars.
# 否则，可能显示内容是乱码, phonon-qt5-vlc 是可选择依赖之一
# ebook-tools 让 okular 支持 epub 格式,
# foliate 支持很多格式，有时候，epub 格式用 okular 打开不正确。
# kdegraphics-mobipocket 则安装了 mobi 插件所需的一个依赖
# shotwell 是一个 ACDSee like 图片查看器。
pacman -S okular poppler-data ebook-tools kdegraphics-mobipocket phonon-qt6-vlc vlc foliate vlc-plugin-ffmpeg shotwell
# 另一个阅读器, 支持 mobi, epub 等格式
# pacman -S fbreader calibre

# bt download
pacman -S transmission-gtk

# dell 显示器 KVM 设置程序, linux 下切换到另一个主机，见我写的 dell_kvm_switch 脚本.
pacman -S ddcutil

# 这个用来打开 terminal 的右键菜单
pacman -S python-nautilus

# ttf-dejavu + xorg-mkfontscale is need for emacs support active fcitx.
# jansson for better json performance for emacs 27.1
# libgccjit for support native compilation.

# Emacs 依赖
# ttf-hanazono 这个干啥的？
# ttf-dejavu 手动安装，jansson 是 neworkmanager 依赖, 已自动安装。
pacman -S xorg-mkfontscale libgccjit libotf tree-sitter tree-sitter-cli hunspell hunspell-en_US
# pacman -S m17n-db m17n-lib  librime ttf-dejavu jansson

# cwebp 用来转化图片到 webp
pacman -S libwebp-utils

pacman -S postgresql-libs

# 一个 docker 的替代
pacman -S podman podman-compose
if ! grep -qs $USER /etc/subuid; then
    # 需要重启才能正确拉取代码
    sudo usermod --add-subuids 100000-165535 $USER
    sudo usermod --add-subgids 100000-165535 $USER
fi

# 配置 podman cross compile, 流程需要换个电脑重新验证下。
pacman -S qemu-user-static qemu-user-static-binfmt

pacman -S zram-generator

# 下面的步骤无须执行，重启就好了。
# sudo modprobe binfmt_misc
# sudo systemctl enable --now proc-sys-fs-binfmt_misc.mount
# sudo systemctl enable --now systemd-binfmt.service


# 如果没有使用 refind, 必须的操作，要求必须不是 GPT 分区。
# grub-install /dev/sda
# grub-mkconfig –o /boot/grub/grub.cfg

systemctl disable iwd



echo '[0m[33mRemember change password for user zw963/root, and generate correct fstab use genfstab command, then reboot.[0m'
