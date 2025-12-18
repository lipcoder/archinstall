
# 1.提示发现了网络并且可以输入密码，但是开始连接后就一直在转圈，然后无法连接，包括直接插网线，

sudo vim /etc/NetworkManager/conf.d/wifi_backend.conf
    [device]
    wifi.backend=iwd

# network手动连接wifi，去排除是kde钱包的问题
nmcli device

nmcli radio

nmcli device wifi list

nmcli device wifi connect "你的SSID" password "你的密码"

# 2.提示DNS解析有问题，但是我的浏览器可以正常上网，但是我的命令行或者说终端都无法连接

1.检查resolv.conf
ls -l /etc/resolv.conf
# 检查resolv为root拥有
# 并且权限为-rw-r--r--

2.重启并且自动启动systemd-resolved服务

3.检查符号链接符号目标
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

4.移除不可变属性
sudo chattr -i /etc/resolv.conf

5.重新创建符号链接
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

6.再次确认符号链接是否指向正确路径
ls -l /etc/resolv.conf
