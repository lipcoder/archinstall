# 因为我当时安装arch几经波折，所以还是希望有一份不错的教程来完成安装
# 当前的脚本只供手敲时参考，无法作为真正的脚本直接安装运行
# 所有p4都是我当前安装的arch的盘，p5为home
# 装系统主要就是装root也就是/根分区,只要能进系统就不需要过多担心

loadkey us #确保键盘为us布局

# -lsblk                        查看当前的所有分区以及分区的大小
# -fdisk -l                     检查所有分区
# -blkid                        查看分区的label
# -cfdisk /dev/nvme0n1p4        操作该分区
# -mkfs.ext4 /dev/nvme0n1p4     格式化该分区为ext4
# -e2label /dev/nvme0n1p4 Arch  设定该分区一个label

mount /dev/nvme0n1p4 /mnt

ip link
# 使用iwctl连接wifi
# iwctl
# station wlan0 get-networks
# station wlan0 connected magic6

# Windows 认为硬件时间是当地时间，而 Linux 认为硬件时间是 UTC+0 标准时间，要确保时间是正确的，否则会发生签名错误
timedatectl set-ntp true
timedatectl set-local-rtc true  # 让 Linux 认为硬件时间是当地时间

#当前我们选择清华源
sed -i '1iServer = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
#也可以直接到文件里面设置

# 将基准包安装到/mnt目标目录中，然后生成新的系统
pacstrap /mnt base base-devel \
        cmake arch-install-scripts vim curl wget \
        rsync net-tools iwd inetutils bind btrfs-progs

# 挂载home分区
mkfs.btrfs /dev/nvme0n1p5
e2label /dev/nvme0n1p5 HOME
mkdir /mnt/home
mount -t btrfs /dev/nvme0n1p5 /mnt/home
# -t btrfs  手指定为btrfs格式，更加安全

#生成fstab条目
genfstab -U /mnt >> /mnt/etc/fstab      #这个方法可能会导致一个结果是把把另一个分区也变成了/切记要检查一下
# -U 使用分区的UUID　 
# /mnt 要扫描的目录
# >> /mnt/etc/fstab 追加到目标文件fstab的末尾,下面是示例
# =============================================================================
# /dev/nvme0n1p4 LABEL=arch
# UUID=5dd62408-2ffa-4365-b3fb-010f5df2e860	/         	ext4      	rw,relatime	0 1
# /dev/nvme0n1p5 LABEL=HOME
# UUID=dba67df7-de20-48ae-a714-053d7febd8f4	/home         	btrfs     	rw,relatime,ssd,discard=async,space_cache=v2,subvol=/	0 0
# =============================================================================

#安装引导
sudo pacman -S refind
umount /mnt && mount /dev/nvme0n1p1 /mnt && cd /mnt
refind-install --alldrivers
# 经过多次的验证，这个办法最为可行
#usedefault 代表不进入交互模式
#alldrivers包括了更多的驱动，原来可能只有ext4

cat > ./EFI/refind/refind.config <<'EOF'
timeout 20
scanfor external,optical,manual

menuentry "Arch Linux with intel-ucode" {
    icon     /EFI/refind/icons/os_arch.png
    volume   "arch"
    loader   /boot/vmlinuz-linux
    initrd   /boot/initramfs-linux.img
    options  "root=LABEL=arch rw initrd=boot\intel-ucode.img sysrq_always_enabled=1"
    submenuentry "Boot using fallback initramfs" {
        initrd /boot/initramfs-linux-fallback.img
    }
    submenuentry "Boot to terminal" {
        add_options "systemd.unit=multi-user.target"
    }
}

menuentry "Windows10" {
   loader \EFI\Microsoft\Boot\bootmgfw.efi
}
EOF

# =============================================================================

#切换到目标　root
umount /mnt && mount /dev/nvme0n1p4 /mnt && arch-chroot /mnt /bin/bash

set -xeu  
#-x（xtrace）：执行每一行命令前，把“将要执行的命令”打印到标准错误，便于调试。
#-e（errexit）：脚本中任一简单命令返回非零状态时，立即退出（有若干例外，见下面“坑点”）。
#-u（nounset）：使用未定义变量时当作错误并退出（如 $foo 未设定）。
# 在这个模式下运行时如果报错会退出虚拟环境，在敲命令时一定要注意是否在虚拟环境里面

useradd -m aria
echo 'aria ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers  #在aria用户登录状态下sudo命令不需要root密码
passwd root #添加root的密码
passwd aria  #添加aria用户的密码

echo 'arch' > /etc/hostname #修改主机的名字

# 调整当前系统显示时间为正确时间/时区，再将系统显示时间写入BIOS时间
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && hwclock -w

#开启需要的locale
sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^#\(zh_CN.UTF-8 UTF-8\)/\1/' /etc/locale.gen
#可以使用 vim /etc/locale.gen,用/命令搜索
#en_US.UTF-8 UTF-8
#zh_CN.UTF-8 UTF-8
#zh_TW.UTF-8 UTF-8
# 然后按x删除#取消注释

locale-gen && echo 'LANG=en_US.UTF-8' > /etc/locale.conf # 更新对应的 locale 文件,设置系统的默认语言环境

#配置镜像源
cat > /etc/pacman.d/mirrorlist <<'EOF'
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
EOF
cat >> /etc/pacman.conf <<EOF
[archlinuxcn]
Server = https://mirrors.bfsu.edu.cn/archlinuxcn/\$arch

[aur-repo]
Server = https://rom.ie8.pub:2443/aur-repo/\$arch
#Server = http://fun.ie8.pub:2442/aur-repo/\$arch
EOF

pacman -S archlinuxcn-keyring pacman-contrib

pacman -Sy && pacman -Fy 

#根据cpu来安装对应的微码包
if grep /proc/cpuinfo -qs -e 'GenuineIntel'; then
    pacman -S intel-ucode
elif grep /proc/cpuinfo -qs -e 'AuthenticAMD'; then
    pacman -S amd-ucode
fi

#安装需要的内核
pacman -S linux linux-headers linux-firmware

#安装显示服务器以及显示管理器
sudo pacman -S xorg     #echo $XDG_SESSION_TYPE 查看当前使用的桌面
sudo pacman -S sddm
sudo systemctl enable sddm

# 安装桌面
sudo pacman -S plasma-desktop

# 必要的桌面软件
sudo pacman -S plasma-systemmonitor dolphin gparted yay firefox konsole

#安装网络服务
sudo pacman -S plasma-nm
sudo pacman -S networkmanager
sudo systemctl enable NetworkManager
