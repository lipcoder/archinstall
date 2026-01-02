#当前的脚本只供手敲时参考，无法作为真正的脚本直接安装运行

set -xeu

loadkey us #确保键盘为us布局

# -lsblk 查看当前的所有分区以及标签和大小
# -fdisk -l 检查所有分区
# -cfdisk /dev/nvme0n1p4 操作该分区
# -mkfs.ext4 /dev/nvme0n1p4 格式化该分区为ext4
# -e2label /dev/nvme0n1p4 Arch 设定该分区一个label
mount /dev/nvme0n1p4 /mnt

##装系统主要就是装root也就是/根分区

#使用iwctl连接wifi
iwctl
station wlan0 get-networks
station wlan0 connected magic6

#要确保时间是正确的，否则会发生签名错误
# Windows 认为硬件时间是当地时间，而 Linux 认为硬件时间是 UTC+0 标准时间
timedatectl set-ntp true
timedatectl set-local-rtc true  # 让 Linux 认为硬件时间是当地时间

#当前我们选择清华源
sed -i '1iServer = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
#也可以直接到文件里面设置

# 将基准包安装到/mnt目标目录中，然后生成新的系统
pacstrap /mnt base base-devel \
        cmake arch-install-scripts vim curl wget \
        rsync net-tools iwd inetutils bind btrfs-progs

####挂载home分区
mkfs.btrfs /dev/nvme0n1p5
e2label /dev/nvme0n1p5 HOME
mkdir /mnt/home
mount -t btrfs /dev/nvme0n1p5 /mnt/home
# -t btrfs  手指定为btrfs格式，更加安全

#生成fstab条目
genfstab -U /mnt >> /mnt/etc/fstab      #这个方法可能会导致一个结果是把把另一个分区也变成了/切记要检查一下
# -U 使用分区的UUID　 
# /mnt 要扫描的目录
# >> /mnt/etc/fstab 追加到目标文件fstab的末尾

#安装引导
sudo pacman -S refind
mkdir -p /123
mount /dev/nvme0n1p1 /123
cd /123
refind-install --alldrivers
# 经过多次的验证，这个办法最为可行
#usedefault 代表不进入交互模式
#alldrivers包括了更多的驱动，原来可能只有ext4


=============================================================================z


#切换到目标　root
arch-chroot /mnt /bin/bash

set -xeu  

#-x（xtrace）：执行每一行命令前，把“将要执行的命令”打印到标准错误，便于调试。
#-e（errexit）：脚本中任一简单命令返回非零状态时，立即退出（有若干例外，见下面“坑点”）。
#-u（nounset）：使用未定义变量时当作错误并退出（如 $foo 未设定）。
# 在这个模式下运行时如果报错会退出虚拟环境，在敲命令时一定要注意是否在虚拟环境里面

useradd -m aria
echo 'aria ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers  #在aria用户登录状态下sudo命令不需要root密码

passwd root #添加root的密码
passwd aria  #添加aria用户的密码

echo 'arch' > /etc/hostname

# 调整当前系统显示时间为正确时间/时区，再将系统显示时间写入BIOS时间
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && hwclock -w

#开启需要的locale
sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^#\(zh_CN.UTF-8 UTF-8\)/\1/' /etc/locale.gen
#用/命令搜索
#vim /etc/locale.gen
#en_US.UTF-8 UTF-8
#zh_CN.UTF-8 UTF-8
#zh_TW.UTF-8 UTF-8

locale-gen

echo 'LANG=en_US.UTF-8' > /etc/locale.conf

#配置镜像源
cat >> /etc/pacman.conf <<EOF
[archlinuxcn]
Server = https://mirrors.bfsu.edu.cn/archlinuxcn/\$arch

[aur-repo]
Server = https://rom.ie8.pub:2443/aur-repo/\$arch
#Server = http://fun.ie8.pub:2442/aur-repo/\$arch
EOF
#vim /etc/pacman.conf
#添加Server
#[archlinuxcn]
#Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch
#[aur-repo]
#Server = https://rom.ie8.pub:2443/aur-repo/$arch
#Server = http://fun.ie8.pub:2442/aur-repo/$arch

pacman -S archlinuxcn-keyring pacman-contrib

pacman -Sy
pacman -Fy  

#根据cpu来安装对应的微码包
pacman -S intel-ucode
# if grep /proc/cpuinfo -qs -e 'GenuineIntel'; then
#     pacman -S intel-ucode
# elif grep /proc/cpuinfo -qs -e 'AuthenticAMD'; then
#     pacman -S amd-ucode
# fi

#安装需要的内核
pacman -S linux linux-headers linux-firmware
pacman -S linux-lts linux-lts-headers

#安装显示服务器
sudo pacman -S xorg xorg-xinit
#现在的kde已经全面拥抱wayland了，我目前不知道怎么使用x11
#echo $XDG_SESSION_TYPE 查看当前使用的桌面

#安装桌面
sudo pacman -S plasma-desktop
sudo pacman -S sddm
sudo systemctl enable sddm

#一些软件　终端　文件管理系统　文本编辑器
sudo pacman -S konsole dolphin kate yay ark firefox yazi gparted plasma-systemmonitor refind

#安装中文字体
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji

#安装网络服务
sudo pacman -S plasma-nm
sudo pacman -S networkmanager
sudo systemctl enable NetworkManager
