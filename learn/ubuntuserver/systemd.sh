
sudo vim /etc/systemd/system/lipcoder.service

# ================================================

[Unit]
Description=Lipcoder Go Server
After=network.target

[Service]
# 程序运行用户
User=azureuser
Group=azureuser

# 工作目录（你的 main 当前所在目录）
WorkingDirectory=/home/azureuser/project/lipcoder

# 启动命令（不要用 ./main，写绝对路径）
ExecStart=/home/azureuser/project/lipcoder/main

# 如果崩了自动重启
Restart=always
RestartSec=3

# 环境变量（有需要再加，没有可以删掉这行）
Environment=PORT=5000

[Install]
WantedBy=multi-user.target

# ================================================

# 重新加载 systemd 配置
sudo systemctl daemon-reload

# 启动服务
sudo systemctl start lipcoder.service

# 设置开机自启
sudo systemctl enable lipcoder.service

systemctl status lipcoder.service

sudo systemctl stop nginx

sudo systemctl disable nginx

