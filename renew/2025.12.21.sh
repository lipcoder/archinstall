

#  介绍一下背景，一开始是我们实验室里面有一个人更新arch炸了，配置基本与我一致，他更新炸了，
# 我选择观望两天他的系统怎么样了，发现稳定了，
# 而且实验室另一个也更新了这个最新系统，不过他纯核显，所以参考意义不大了，
# 这个commit提交前我都是未重启的状态，我不知道会不会炸掉，我提前把所有日志写到这个文件里面了，如果炸了，我好再找原因



 ╭─ 15:57  aria
 ╰──➤ $ sudo pacman -Syu
:: Synchronizing package databases...
 core                                                     117.8 KiB  89.2 KiB/s 00:01 [#################################################] 100%
 extra                                                      8.1 MiB  1743 KiB/s 00:05 [#################################################] 100%
 multilib                                                 126.6 KiB  73.0 KiB/s 00:02 [#################################################] 100%
 archlinuxcn                                             1358.0 KiB   713 KiB/s 00:02 [#################################################] 100%
 aur-repo                                                 323.0 KiB   157 KiB/s 00:02 [#################################################] 100%
:: Starting full system upgrade...
:: Replace nvidia with extra/nvidia-open? [Y/n] n
resolving dependencies...
looking for conflicting packages...
error: failed to prepare transaction (could not satisfy dependencies)
:: installing nvidia-utils (590.48.01-1) breaks dependency 'nvidia-utils=580.105.08' required by nvidia



 ╭─ 16:16  aria  ~ 
 ╰──➤ $ 1  pacman -Q | grep -E 'nvidia|linux'
archlinux-keyring 20251116-1
archlinuxcn-keyring 20250531-1
lib32-nvidia-utils 580.105.08-1
lib32-util-linux 2.41.3-1
linux 6.17.9.arch1-1
linux-api-headers 6.17-1
linux-firmware 20251125-2
linux-firmware-amdgpu 20251125-2
linux-firmware-atheros 20251125-2
linux-firmware-broadcom 20251125-2
linux-firmware-cirrus 20251125-2
linux-firmware-intel 20251125-2
linux-firmware-mediatek 20251125-2
linux-firmware-nvidia 20251125-2
linux-firmware-other 20251125-2
linux-firmware-radeon 20251125-2
linux-firmware-realtek 20251125-2
linux-firmware-whence 20251125-2
linux-headers 6.17.9.arch1-1
linux-zen 6.17.9.zen1-1
linux-zen-headers 6.17.9.zen1-1
nvidia 580.105.08-4
nvidia-settings 580.105.08-1
nvidia-utils 580.105.08-5
util-linux 2.41.3-1
util-linux-libs 2.41.3-1

# ===============================================================================================================================================

# 1) 一次性在同一事务里完成升级与切换（避免半升级）
sudo pacman -Syu nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings

# 2) 保险起见重建 initramfs
sudo mkinitcpio -P


# ===============================================================================================================================================

 ╭─ 16:26  aria  ~ 
 ╰──➤ $ pacman -Si nvidia-utils | sed -n '1,20p'
Repository      : extra
Name            : nvidia-utils
Version         : 590.48.01-1
Description     : NVIDIA drivers utilities
Architecture    : x86_64
URL             : http://www.nvidia.com/
Licenses        : custom
Groups          : None
Provides        : vulkan-driver  opengl-driver  nvidia-libgl
Depends On      : libglvnd  egl-wayland  egl-wayland2  egl-gbm  egl-x11
Optional Deps   : nvidia-settings: configuration tool
                  xorg-server: Xorg support
                  xorg-server-devel: nvidia-xconfig
                  opencl-nvidia: OpenCL support
Conflicts With  : nvidia-libgl
Replaces        : nvidia-libgl
Download Size   : 277.96 MiB
Installed Size  : 853.92 MiB
Packager        : Peter Jung <ptr1337@archlinux.org>
Build Date      : Fri Dec 19 00:56:03 2025

 ╭─ 16:28  aria  ~ 
 ╰──➤ $ sudo pacman -Syu nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
:: Synchronizing package databases...
 core is up to date
 extra is up to date
 multilib is up to date
 archlinuxcn is up to date
 aur-repo is up to date
:: Starting full system upgrade...
:: Replace nvidia with extra/nvidia-open? [Y/n] y
resolving dependencies...
looking for conflicting packages...
warning: removing 'nvidia-open-590.48.01-3' from target list because it conflicts with 'nvidia-open-dkms-590.48.01-1'
:: nvidia-open-dkms-590.48.01-1 and nvidia-580.105.08-4 are in conflict (NVIDIA-MODULE). Remove nvidia? [y/N] y

Packages (41) bind-9.20.17-1  chromium-143.0.7499.169-1  device-mapper-2.03.38-1  dkms-3.3.0-1  egl-wayland-4:1.1.21-1
              egl-wayland2-1.0.0.rc.r51.gada1c37-1  egl-x11-1.0.4-1  enchant-2.8.14-1  firefox-146.0.1-1  lib32-mesa-1:25.3.2-1
              lib32-systemd-259-1  lib32-xz-5.8.2-1  libdecor-0.2.5-1  libnotify-0.8.7-2  libpulse-17.0+r98+gb096704c0-1  libsigc++-2.12.1-2
              libsigc++-3.0-3.8.0-1  liburing-2.13-1  libvpl-2.16.0-1  libxnvctrl-590.48.01-1  linux-6.18.2.arch2-1
              linux-headers-6.18.2.arch2-1  linux-zen-6.18.2.zen2-1  linux-zen-headers-6.18.2.zen2-1  mesa-1:25.3.2-1  mkinitcpio-40-3
              noto-fonts-1:2025.12.01-2  nvidia-580.105.08-4 [removal]  opus-1.6-1  polkit-127-1  sof-firmware-2025.12-1  systemd-259-1
              systemd-libs-259-1  systemd-sysvcompat-259-1  telegram-desktop-6.3.9-1  visual-studio-code-bin-1.107.1-1  xz-5.8.2-1
              lib32-nvidia-utils-590.48.01-1  nvidia-open-dkms-590.48.01-1  nvidia-settings-590.48.01-1  nvidia-utils-590.48.01-1

Total Download Size:   1204.57 MiB
Total Installed Size:  3724.58 MiB
Net Upgrade Size:       148.06 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 visual-studio-code-bin-1.107.1-1-x86_64                  113.6 MiB  11.0 MiB/s 00:10 [#################################################] 100%
 chromium-143.0.7499.169-1-x86_64                         117.7 MiB  9.70 MiB/s 00:12 [#################################################] 100%
 linux-6.18.2.arch2-1-x86_64                              142.9 MiB  10.3 MiB/s 00:14 [#################################################] 100%
 lib32-nvidia-utils-590.48.01-1-x86_64                     85.1 MiB  11.5 MiB/s 00:07 [#################################################] 100%
 firefox-146.0.1-1-x86_64                                  78.5 MiB  6.73 MiB/s 00:12 [#################################################] 100%
 nvidia-utils-590.48.01-1-x86_64                          278.0 MiB  10.9 MiB/s 00:25 [#################################################] 100%
 linux-zen-headers-6.18.2.zen2-1-x86_64                    58.2 MiB  4.58 MiB/s 00:13 [#################################################] 100%
 linux-headers-6.18.2.arch2-1-x86_64                       57.2 MiB  5.47 MiB/s 00:10 [#################################################] 100%
 telegram-desktop-6.3.9-1-x86_64                           40.6 MiB  6.81 MiB/s 00:06 [#################################################] 100%
 noto-fonts-1:2025.12.01-2-any                             27.8 MiB  4.97 MiB/s 00:06 [#################################################] 100%
 nvidia-open-dkms-590.48.01-1-x86_64                       12.1 MiB  2.59 MiB/s 00:05 [#################################################] 100%
 lib32-mesa-1:25.3.2-1-x86_64                              11.3 MiB  4.12 MiB/s 00:03 [#################################################] 100%
 mesa-1:25.3.2-1-x86_64                                    11.2 MiB  6.08 MiB/s 00:02 [#################################################] 100%
 systemd-259-1-x86_64                                       9.4 MiB  7.30 MiB/s 00:01 [#################################################] 100%
 opus-1.6-1-x86_64                                          3.3 MiB  2.89 MiB/s 00:01 [#################################################] 100%
 bind-9.20.17-1-x86_64                                      2.1 MiB  2.38 MiB/s 00:01 [#################################################] 100%
 sof-firmware-2025.12-1-x86_64                           1683.2 KiB  2.60 MiB/s 00:01 [#################################################] 100%
 linux-zen-6.18.2.zen2-1-x86_64                           148.0 MiB  4.48 MiB/s 00:33 [#################################################] 100%
 systemd-libs-259-1-x86_64                               1276.1 KiB  5.37 MiB/s 00:00 [#################################################] 100%
 xz-5.8.2-1-x86_64                                        839.5 KiB  6.95 MiB/s 00:00 [#################################################] 100%
 lib32-systemd-259-1-x86_64                               838.6 KiB  5.53 MiB/s 00:00 [#################################################] 100%
 nvidia-settings-590.48.01-1-x86_64                       774.7 KiB  5.52 MiB/s 00:00 [#################################################] 100%
 polkit-127-1-x86_64                                      413.8 KiB  3.11 MiB/s 00:00 [#################################################] 100%
 libpulse-17.0+r98+gb096704c0-1-x86_64                    401.5 KiB  4.00 MiB/s 00:00 [#################################################] 100%
 device-mapper-2.03.38-1-x86_64                           281.7 KiB  2.25 MiB/s 00:00 [#################################################] 100%
 libvpl-2.16.0-1-x86_64                                   227.5 KiB  1580 KiB/s 00:00 [#################################################] 100%
 liburing-2.13-1-x86_64                                   215.3 KiB  1905 KiB/s 00:00 [#################################################] 100%
 lib32-xz-5.8.2-1-x86_64                                  104.8 KiB  1027 KiB/s 00:00 [#################################################] 100%
 enchant-2.8.14-1-x86_64                                   76.5 KiB   649 KiB/s 00:00 [#################################################] 100%
 libxnvctrl-590.48.01-1-x86_64                             76.0 KiB   884 KiB/s 00:00 [#################################################] 100%
 libsigc++-2.12.1-2-x86_64                                 67.6 KiB   676 KiB/s 00:00 [#################################################] 100%
 libsigc++-3.0-3.8.0-1-x86_64                              51.6 KiB  1322 KiB/s 00:00 [#################################################] 100%
 mkinitcpio-40-3-any                                       67.1 KiB   861 KiB/s 00:00 [#################################################] 100%
 dkms-3.3.0-1-any                                          48.0 KiB   857 KiB/s 00:00 [#################################################] 100%
 libdecor-0.2.5-1-x86_64                                   45.3 KiB   687 KiB/s 00:00 [#################################################] 100%
 libnotify-0.8.7-2-x86_64                                  38.8 KiB   776 KiB/s 00:00 [#################################################] 100%
 egl-x11-1.0.4-1-x86_64                                    38.2 KiB   887 KiB/s 00:00 [#################################################] 100%
 egl-wayland2-1.0.0.rc.r51.gada1c37-1-x86_64               37.5 KiB   506 KiB/s 00:00 [#################################################] 100%
 egl-wayland-4:1.1.21-1-x86_64                             36.9 KiB   724 KiB/s 00:00 [#################################################] 100%
 systemd-sysvcompat-259-1-x86_64                            6.1 KiB   120 KiB/s 00:00 [#################################################] 100%
 Total (40/40)                                           1204.6 MiB  35.7 MiB/s 00:34 [#################################################] 100%
(40/40) checking keys in keyring                                                      [#################################################] 100%
(40/40) checking package integrity                                                    [#################################################] 100%
(40/40) loading package files                                                         [#################################################] 100%
(40/40) checking for file conflicts                                                   [#################################################] 100%
(41/41) checking available disk space                                                 [#################################################] 100%
:: Running pre-transaction hooks...
(1/1) Removing linux initcpios...
corrupted size vs. prev_size in fastbins
error: command terminated by signal 6: Aborted
:: Processing package changes...
(1/1) removing nvidia                                                                 [#################################################] 100%
( 1/40) upgrading xz                                                                  [#################################################] 100%
( 2/40) upgrading systemd-libs                                                        [#################################################] 100%
( 3/40) installing dkms                                                               [#################################################] 100%
Optional dependencies for dkms
    linux-headers: build modules against the Arch kernel [installed]
    linux-lts-headers: build modules against the LTS kernel
    linux-zen-headers: build modules against the ZEN kernel [installed]
    linux-hardened-headers: build modules against the HARDENED kernel
( 4/40) upgrading mesa                                                                [#################################################] 100%
( 5/40) upgrading egl-wayland                                                         [#################################################] 100%
( 6/40) installing egl-wayland2                                                       [#################################################] 100%
( 7/40) upgrading egl-x11                                                             [#################################################] 100%
( 8/40) upgrading nvidia-utils                                                        [#################################################] 100%
( 9/40) installing nvidia-open-dkms                                                   [#################################################] 100%
(10/40) upgrading lib32-xz                                                            [#################################################] 100%
(11/40) upgrading lib32-mesa                                                          [#################################################] 100%
(12/40) upgrading lib32-nvidia-utils                                                  [#################################################] 100%
(13/40) upgrading libxnvctrl                                                          [#################################################] 100%
(14/40) upgrading nvidia-settings                                                     [#################################################] 100%
(15/40) upgrading bind                                                                [#################################################] 100%
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(16/40) upgrading device-mapper                                                       [#################################################] 100%
(17/40) upgrading systemd                                                             [#################################################] 100%
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(18/40) upgrading opus                                                                [#################################################] 100%
(19/40) upgrading libpulse                                                            [#################################################] 100%
(20/40) upgrading chromium                                                            [#################################################] 100%
(21/40) upgrading enchant                                                             [#################################################] 100%
(22/40) upgrading noto-fonts                                                          [#################################################] 100%
(23/40) upgrading libvpl                                                              [#################################################] 100%
(24/40) upgrading firefox                                                             [#################################################] 100%
(25/40) upgrading lib32-systemd                                                       [#################################################] 100%
(26/40) upgrading libdecor                                                            [#################################################] 100%
(27/40) upgrading libnotify                                                           [#################################################] 100%
(28/40) upgrading libsigc++                                                           [#################################################] 100%
(29/40) upgrading libsigc++-3.0                                                       [#################################################] 100%
(30/40) upgrading liburing                                                            [#################################################] 100%
(31/40) upgrading mkinitcpio                                                          [#################################################] 100%
(32/40) upgrading linux                                                               [#################################################] 100%
(33/40) upgrading linux-headers                                                       [#################################################] 100%
(34/40) upgrading linux-zen                                                           [#################################################] 100%
(35/40) upgrading linux-zen-headers                                                   [#################################################] 100%
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(36/40) upgrading polkit                                                              [#################################################] 100%
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(37/40) upgrading sof-firmware                                                        [#################################################] 100%
(38/40) upgrading systemd-sysvcompat                                                  [#################################################] 100%
(39/40) upgrading telegram-desktop                                                    [#################################################] 100%
(40/40) upgrading visual-studio-code-bin                                              [#################################################] 100%
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
:: Running post-transaction hooks...
( 1/20) Creating system user accounts...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
( 2/20) Updating journal message catalog...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
( 3/20) Reloading system manager configuration...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
( 4/20) Reloading user manager configuration...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
( 5/20) Updating udev hardware database...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
( 6/20) Restarting marked services...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
( 7/20) Applying kernel sysctl settings...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
( 8/20) Creating temporary files...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
( 9/20) Reloading device manager configuration...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(10/20) Arming ConditionNeedsUpdate...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(11/20) Updating the MIME type database...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(12/20) Updating fontconfig configuration...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(13/20) Updating module dependencies...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(14/20) Install DKMS modules
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(15/20) Updating linux initcpios...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(16/20) Reloading system bus configuration...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(17/20) Updating fontconfig cache...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(18/20) Updating 32-bit fontconfig cache...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(19/20) Updating icon theme caches...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted
(20/20) Updating the desktop file MIME type cache...
double free or corruption (!prev)
error: command terminated by signal 6: Aborted

# ===============================================================================================================================================

# 先确认 pacman 事务结束后没有残留未完成升级：

sudo pacman -Syu

如果它显示 “there is nothing to do”，继续做两个关键动作（它们在 hook 里失败过，现在手动补齐）：

# 1.1 重新生成 initramfs
sudo mkinitcpio -P

# 1.2 重新触发 DKMS 构建（给 linux + zen)
sudo dkms autoinstall

# 然后确认 NVIDIA 模块是否存在且能加载（不重启也能看出大概）：

modinfo nvidia 2>/dev/null | head
ls /usr/lib/modules/$(uname -r)/updates/dkms | grep -i nvidia || true

如果 mkinitcpio -P / dkms autoinstall 仍然出现同样的 double free abort，先不要急着重启——先按第 2 部分排查“为何所有程序都在堆崩溃”。

# ===============================================================================================================================================

╭─ 16:34  aria  ~ 
 ╰──➤ $ sudo mkinitcpio -P
==> Building image from preset: /etc/mkinitcpio.d/linux-zen.preset: 'default'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux-zen -g /boot/initramfs-linux-zen.img
==> Starting build: '6.17.9-zen1-1-zen'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
==> ERROR: module not found: 'crypto_lzo'
  -> Running build hook: [autodetect]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
==> WARNING: No module containing the symbol 'drm_privacy_screen_register' found in: 'drivers/platform'
  -> Running build hook: [keyboard]
==> ERROR: module not found: 'usbhid'
  -> Running build hook: [keymap]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/crypto/lz4.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/usb/storage/usb-storage.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/mmc/core/mmc_block.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/nvme/host/nvme.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/scsi/virtio_scsi.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/usb/storage/uas.ko.zst'
==> Generating module dependencies
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/modules.builtin'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/modules.builtin.modinfo'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/modules.order'
depmod: WARNING: could not open modules.order at /tmp/mkinitcpio.B0iQ8v/root/lib/modules/6.17.9-zen1-1-zen: No such file or directory
depmod: WARNING: could not open modules.builtin at /tmp/mkinitcpio.B0iQ8v/root/lib/modules/6.17.9-zen1-1-zen: No such file or directory
depmod: WARNING: could not open modules.builtin.modinfo at /tmp/mkinitcpio.B0iQ8v/root/lib/modules/6.17.9-zen1-1-zen: No such file or directory
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-zen.img'
==> WARNING: errors were encountered during the build. The image may not be complete.
==> Building image from preset: /etc/mkinitcpio.d/linux-zen.preset: 'fallback'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux-zen -g /boot/initramfs-linux-zen-fallback.img -S autodetect
==> Starting build: '6.17.9-zen1-1-zen'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
==> ERROR: module not found: 'crypto_lzo'
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
==> WARNING: No module containing the symbol 'drm_privacy_screen_register' found in: 'drivers/platform'
  -> Running build hook: [keyboard]
==> ERROR: module not found: 'usbhid'
  -> Running build hook: [keymap]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/crypto/lz4.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/usb/storage/usb-storage.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/mmc/core/mmc_block.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/nvme/host/nvme.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/scsi/virtio_scsi.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/kernel/drivers/usb/storage/uas.ko.zst'
==> Generating module dependencies
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/modules.builtin'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/modules.builtin.modinfo'
==> ERROR: file not found: '/lib/modules/6.17.9-zen1-1-zen/modules.order'
depmod: WARNING: could not open modules.order at /tmp/mkinitcpio.icb9qV/root/lib/modules/6.17.9-zen1-1-zen: No such file or directory
depmod: WARNING: could not open modules.builtin at /tmp/mkinitcpio.icb9qV/root/lib/modules/6.17.9-zen1-1-zen: No such file or directory
depmod: WARNING: could not open modules.builtin.modinfo at /tmp/mkinitcpio.icb9qV/root/lib/modules/6.17.9-zen1-1-zen: No such file or directory
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-zen-fallback.img'
==> WARNING: errors were encountered during the build. The image may not be complete.
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux -g /boot/initramfs-linux.img
==> Starting build: '6.17.9-arch1-1'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
==> ERROR: module not found: 'crypto_lzo'
  -> Running build hook: [autodetect]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
==> WARNING: No module containing the symbol 'drm_privacy_screen_register' found in: 'drivers/platform'
  -> Running build hook: [keyboard]
==> ERROR: module not found: 'usbhid'
  -> Running build hook: [keymap]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/mmc/core/mmc_block.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/nvme/host/nvme.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/usb/storage/usb-storage.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/usb/storage/uas.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/crypto/lz4.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/scsi/virtio_scsi.ko.zst'
==> Generating module dependencies
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/modules.builtin'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/modules.builtin.modinfo'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/modules.order'
depmod: WARNING: could not open modules.order at /tmp/mkinitcpio.O3aVBi/root/lib/modules/6.17.9-arch1-1: No such file or directory
depmod: WARNING: could not open modules.builtin at /tmp/mkinitcpio.O3aVBi/root/lib/modules/6.17.9-arch1-1: No such file or directory
depmod: WARNING: could not open modules.builtin.modinfo at /tmp/mkinitcpio.O3aVBi/root/lib/modules/6.17.9-arch1-1: No such file or directory
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux.img'
==> WARNING: errors were encountered during the build. The image may not be complete.
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: '6.17.9-arch1-1'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
==> ERROR: module not found: 'crypto_lzo'
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
==> WARNING: No module containing the symbol 'drm_privacy_screen_register' found in: 'drivers/platform'
  -> Running build hook: [keyboard]
==> ERROR: module not found: 'usbhid'
  -> Running build hook: [keymap]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/mmc/core/mmc_block.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/nvme/host/nvme.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/usb/storage/usb-storage.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/usb/storage/uas.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/crypto/lz4.ko.zst'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/kernel/drivers/scsi/virtio_scsi.ko.zst'
==> Generating module dependencies
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/modules.builtin'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/modules.builtin.modinfo'
==> ERROR: file not found: '/lib/modules/6.17.9-arch1-1/modules.order'
depmod: WARNING: could not open modules.order at /tmp/mkinitcpio.FEM4Jz/root/lib/modules/6.17.9-arch1-1: No such file or directory
depmod: WARNING: could not open modules.builtin at /tmp/mkinitcpio.FEM4Jz/root/lib/modules/6.17.9-arch1-1: No such file or directory
depmod: WARNING: could not open modules.builtin.modinfo at /tmp/mkinitcpio.FEM4Jz/root/lib/modules/6.17.9-arch1-1: No such file or directory
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-fallback.img'
==> WARNING: errors were encountered during the build. The image may not be complete.


 ╭─ 16:38  aria  ~ 
 ╰──➤ $ sed -n '1,120p' /etc/mkinitcpio.d/linux.preset
sed -n '1,120p' /etc/mkinitcpio.d/linux-zen.preset
# mkinitcpio preset file for the 'linux' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
default_image="/boot/initramfs-linux.img"
#default_uki="/efi/EFI/Linux/arch-linux.efi"
#default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux-fallback.img"
#fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
# mkinitcpio preset file for the 'linux-zen' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux-zen"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
default_image="/boot/initramfs-linux-zen.img"
#default_uki="/efi/EFI/Linux/arch-linux-zen.efi"
#default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux-zen-fallback.img"
#fallback_uki="/efi/EFI/Linux/arch-linux-zen-fallback.efi"
fallback_options="-S autodetect"

# ===============================================================================================================================================

# 这份 mkinitcpio -P 输出把根因直接暴露出来了：你系统里“正在生成 initramfs 的内核版本（6.17.9…）”对应的 /lib/modules/<版本>/ 目录已经不存在或不完整。
# 所以 mkinitcpio 找不到大量基础模块（usbhid、nvme、usb-storage、lz4 等），最终连 modules.builtin / modules.order 都缺失。换句话说：你现在处于一个典型的“内核包已升级到 6.18.2，
# 但 mkinitcpio 还在用旧 preset 指向 6.17.9 / 或旧模块目录被删但预设未更新”的半一致状态。

# 这和你之前 pacman 输出里看到的 “Removing linux initcpios…” 钩子异常是同一条链路：hook 崩了，initramfs 没正确重建；现在你手动跑 mkinitcpio 又因为指向旧内核版本而找不到模块目录。

ls -1 /lib/modules

sudo pacman -S linux linux-headers linux-zen linux-zen-headers

# 确保 mkinitcpio preset 已经指向 6.18.2（而不是 6.17.9）
sed -n '1,120p' /etc/mkinitcpio.d/linux.preset
sed -n '1,120p' /etc/mkinitcpio.d/linux-zen.preset

# 重新生成 initramfs（这次应当针对 6.18.2）
sudo mkinitcpio -P

# ===============================================================================================================================================



 ╭─ 16:38  aria  ~ 
 ╰──➤ $ sed -n '1,120p' /etc/mkinitcpio.d/linux.preset
sed -n '1,120p' /etc/mkinitcpio.d/linux-zen.preset
# mkinitcpio preset file for the 'linux' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
default_image="/boot/initramfs-linux.img"
#default_uki="/efi/EFI/Linux/arch-linux.efi"
#default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux-fallback.img"
#fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
# mkinitcpio preset file for the 'linux-zen' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux-zen"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
default_image="/boot/initramfs-linux-zen.img"
#default_uki="/efi/EFI/Linux/arch-linux-zen.efi"
#default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux-zen-fallback.img"
#fallback_uki="/efi/EFI/Linux/arch-linux-zen-fallback.efi"
fallback_options="-S autodetect"

 ╭─ 16:38  aria  ~ 
 ╰──➤ $ sudo mkinitcpio -P
==> Building image from preset: /etc/mkinitcpio.d/linux-zen.preset: 'default'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux-zen -g /boot/initramfs-linux-zen.img
==> Starting build: '6.18.2-zen2-1-zen'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [autodetect]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [keymap]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-zen.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux-zen.preset: 'fallback'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux-zen -g /boot/initramfs-linux-zen-fallback.img -S autodetect
==> Starting build: '6.18.2-zen2-1-zen'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
==> WARNING: Possibly missing firmware for module: 'ast'
  -> Running build hook: [keyboard]
==> WARNING: Possibly missing firmware for module: 'xhci_pci_renesas'
  -> Running build hook: [keymap]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
==> WARNING: Possibly missing firmware for module: 'qed'
==> WARNING: Possibly missing firmware for module: 'qla1280'
==> WARNING: Possibly missing firmware for module: 'aic94xx'
==> WARNING: Possibly missing firmware for module: 'wd719x'
==> WARNING: Possibly missing firmware for module: 'bfa'
==> WARNING: Possibly missing firmware for module: 'qla2xxx'
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-zen-fallback.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux -g /boot/initramfs-linux.img
==> Starting build: '6.18.2-arch2-1'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [autodetect]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [keymap]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: '6.18.2-arch2-1'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
==> WARNING: Possibly missing firmware for module: 'ast'
  -> Running build hook: [keyboard]
==> WARNING: Possibly missing firmware for module: 'xhci_pci_renesas'
  -> Running build hook: [keymap]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
==> WARNING: Possibly missing firmware for module: 'qed'
==> WARNING: Possibly missing firmware for module: 'qla1280'
==> WARNING: Possibly missing firmware for module: 'aic94xx'
==> WARNING: Possibly missing firmware for module: 'wd719x'
==> WARNING: Possibly missing firmware for module: 'bfa'
==> WARNING: Possibly missing firmware for module: 'qla2xxx'
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-fallback.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful

 ╭─ 16:39  aria  ~ 
 ╰──➤ $ sudo dkms autoinstall

Error! Your kernel headers for kernel 6.17.9-arch1-1 cannot be found at /usr/lib/modules/6.17.9-arch1-1/build or /usr/lib/modules/6.17.9-arch1-1/source.
Please install the linux-headers-6.17.9-arch1-1 package or use the --kernelsourcedir option to tell DKMS where it's located.

 ╭─ 16:39  aria  ~ 
 ╰──➤ $ 21  sudo dkms autoinstall

Error! Your kernel headers for kernel 6.17.9-arch1-1 cannot be found at /usr/lib/modules/6.17.9-arch1-1/build or /usr/lib/modules/6.17.9-arch1-1/source.
Please install the linux-headers-6.17.9-arch1-1 package or use the --kernelsourcedir option to tell DKMS where it's located.

 ╭─ 16:39  aria  ~ 
 ╰──➤ $ 21  ls /usr/lib/modules/*/updates/dkms 2>/dev/null | grep -i nvidia || true
nvidia-drm.ko.zst
nvidia-modeset.ko.zst
nvidia-peermem.ko.zst
nvidia-uvm.ko.zst
nvidia.ko.zst
nvidia-drm.ko.zst
nvidia-modeset.ko.zst
nvidia-peermem.ko.zst
nvidia-uvm.ko.zst
nvidia.ko.zst

# 进展很好：mkinitcpio -P 已经针对 6.18.2（arch + zen） 全部成功生成了 initramfs，你现在“可启动性”基本恢复了。
# 你看到的那些 firmware 警告（ast、qla2xxx 等）是 fallback 镜像包含大量硬件驱动导致的常见提示，通常可以忽略，不影响你的 4060。

# 现在剩下的唯一“硬错误”是 DKMS 还在盯着一个 已经不存在的旧内核 6.17.9-arch1-1，
# 所以它报找不到 headers。你已经用 ls /usr/lib/modules/*/updates/dkms 看到 nvidia 模块其实已经为现有内核生成了（两套内核各一份），这说明核心目标基本达成；
# 只是 DKMS 的自动流程还想给旧内核做一遍，于是失败。
ls -1 /usr/lib/modules

uname -r
pacman -Q linux linux-zen

# 对 arch 内核
sudo dkms autoinstall -k 6.18.2-arch2-1

# 对 zen 内核
sudo dkms autoinstall -k 6.18.2-zen2-1-zen

pacman -Q | grep -E '^linux-headers|^linux-zen-headers'

