# 因为我当时安装arch几经波折，所以还是希望有一份不错的教程来完成安装
# 当前的脚本只供手敲时参考，无法作为真正的脚本直接安装运行
# 所有p4都是我当前安装的arch的盘，p5为home
# 装系统主要就是装root也就是/根分区,只要能进系统就不需要过多担心

loadkeys us #确保键盘为us布局

# -lsblk                        查看当前的所有分区以及分区的大小,-f 查看label和uuid
# -fdisk -l                     检查所有分区
# -blkid                        查看分区的label,可能第一下不会出答案
# -cfdisk /dev/nvme0n1          操作该分区或者硬盘，主要是为了给未分区的地方分区
# -mkfs.ext4 /dev/nvme0n1p4     格式化该分区为ext4
# -e2label /dev/nvme0n1p4 Arch  设定该分区一个label

mount /dev/nvme0n1p4 /mnt

ip a
# iwctl	使用iwctl连接wifi
# station wlan0 get-networks
# station wlan0 connected magic6

# Windows 认为硬件时间是当地时间，而 Linux 认为硬件时间是 UTC+0 标准时间，要确保时间是正确的，否则会发生签名错误
timedatectl set-ntp true
timedatectl set-local-rtc true # 让 Linux 认为硬件时间是当地时间

# 当前我们选择清华源
sed -i '1iServer = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
#也可以直接到文件里面设置

# 将基准包安装到/mnt目标目录中，然后生成新的系统
pacstrap /mnt base base-devel \
	cmake arch-install-scripts vim curl \
	iproute2 inetutils bind
# base                  - 系统最小基础环境（能启动、能进 shell、基础工具）
# base-devel            - 编译/构建工具链包组（make/gcc 等，便于编译软件与用 AUR）
# cmake                 - 构建系统生成器（很多源码/软件编译会用到）
# arch-install-scripts  - Arch 安装辅助工具（pacstrap/genfstab/arch-chroot）    -生成fstab
# vim                   - 终端文本编辑器
# curl                  - 命令行 HTTP(S) 客户端（下载、请求接口、测试服务）
# iproute2              - 现代网络/链路/路由管理工具（ip、ss 等，替代 net-tools）
# inetutils             - 常用网络小工具集合（如 ping、hostname、telnet 等）
# bind                  - DNS 查询/诊断工具（dig、host、nslookup）
# btrfs-progs           - Btrfs 文件系统工具（创建、子卷/快照管理、检查维护）

# 挂载home分区
mkfs.ext4 /dev/nvme0n1p5
e2label /dev/nvme0n1p5 HOME
mkdir /mnt/home
mount -t ext4 /dev/nvme0n1p5 /mnt/home
# -t btrfs  手指定为btrfs格式，更加安全

# swapfile
fallocate -l 8G /mnt/swapfile # 创建swapfile
chmod 600 /mnt/swapfile       # 控制权限
mkswap /mnt/swapfile          # 格式化为 swap
swapon /mnt/swapfile          # 启用
swapon --show                 # 检查swap是否启用

# 生成fstab条目
genfstab -U /mnt >>/mnt/etc/fstab # 这个方法可能会导致一个结果是把把另一个分区也变成了/切记要检查一下
# -U 使用分区的UUID
# /mnt 要扫描的目录
# >> /mnt/etc/fstab 追加到目标文件fstab的末尾,下面是示例
# =============================================================================
# /dev/nvme0n1p4 LABEL=arch
# UUID=...	/         	ext4      	rw,relatime	0 1
# /dev/nvme0n1p5 LABEL=HOME
# UUID=...	/home         	btrfs     	rw,relatime,ssd,discard=async,space_cache=v2,subvol=/	0 0
# =============================================================================

# 切换到目标　root
arch-chroot /mnt /bin/bash

set -xeu
# -x（xtrace）：执行每一行命令前，把“将要执行的命令”打印到标准错误，便于调试。
# -e（errexit）：脚本中任一简单命令返回非零状态时，立即退出
# -u（nounset）：使用未定义变量时当作错误并退出（如 $foo 未设定）。
#  在这个模式下运行时如果报错会退出虚拟环境，在敲命令时一定要注意是否在虚拟环境里面

useradd -m aria
echo 'aria ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers # 在aria用户登录状态下sudo命令不需要root密码
passwd root                                        # 添加root的密码
passwd aria                                        # 添加aria用户的密码

echo 'arch' >/etc/hostname # 修改主机的名字

# 调整当前系统显示时间为正确时间/时区，再将系统显示时间写入BIOS时间
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && hwclock -w

# 开启需要的locale
sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^#\(zh_CN.UTF-8 UTF-8\)/\1/' /etc/locale.gen
# 可以使用 vim /etc/locale.gen,用/命令搜索,然后按x删除#取消注释
# en_US.UTF-8 UTF-8
# zh_CN.UTF-8 UTF-8
# zh_TW.UTF-8 UTF-8

# 更新对应的 locale 文件,设置系统的默认语言环境
locale-gen && localectl set-locale LANG=en_US.UTF-8

# 配置镜像源
cat >/etc/pacman.d/mirrorlist <<'EOF'
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
EOF
cat >>/etc/pacman.conf <<EOF
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
EOF

pacman -Sy && pacman -Fy
pacman -S archlinuxcn-keyring pacman-contrib

# 根据cpu来安装对应的微码包
if grep /proc/cpuinfo -qs -e 'GenuineIntel'; then
	pacman -S intel-ucode
elif grep /proc/cpuinfo -qs -e 'AuthenticAMD'; then
	pacman -S amd-ucode
fi

# 安装需要的内核
#mkinitcpio v40把sd-vconsole加进了默认hook，而v39.2的默认mkinitcpio.conf里没有
echo "KEYMAP=us" >/etc/vconsole.conf
pacman -S linux linux-headers linux-firmware

# 安装网络服务
pacman -S networkmanager
systemctl enable NetworkManager
# nmcli device wifi list
# nmcli device wifi connect "wifi" password "12345678"

# 安装gnome
sudo pacman -S gnome gdm
sudo systemctl enable gdm
# 安装显示管理器以及安装KDE桌面(包括x11和wayland)
# 安装完整当plasma可以避免遇到kde钱包弹窗的问题
sudo pacman -S sddm xorg-server plasma plasma-x11-session kwin-x11
sudo systemctl enable sddm
sudo pacman -S dolphin
# echo $XDG_SESSION_TYPE 查看当前使用的

# 安装引导
sudo pacman -S refind
umount /mnt && mount /dev/nvme0n1p1 /mnt
refind-install --alldrivers
# 经过多次的验证，这个办法最为可行
# usedefault 代表不进入交互模式
# alldrivers包括了更多的驱动，原来可能只有ext4
# 重启后refind检测不到arch的时候优先排查内核文件是否存在
