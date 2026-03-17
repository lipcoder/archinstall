#!/usr/bin/env bash
set -euo pipefail

SHARE_PATH="/data/data"

SERVICE_USER="${SUDO_USER:-$(id -un)}"
SERVICE_GROUP="$(id -gn "$SERVICE_USER")"

sudo apt-get update
sudo apt-get install -y samba

sudo mkdir -p "$SHARE_PATH"
sudo chown -R "$SERVICE_USER:$SERVICE_GROUP" "$SHARE_PATH"

sudo tee /etc/samba/smb.conf >/dev/null <<EOF
[global]
   workgroup = WORKGROUP
   server role = standalone server

   # 允许匿名映射
   map to guest = bad user
   # 禁用 SMB1，强制 SMB2+
   server min protocol = SMB2
   # 关闭打印功能
   load printers = no
   disable spoolss = yes

[media]
   path = $SHARE_PATH
   browseable = yes
   read only = no
   guest ok = yes
   force user = $SERVICE_USER
EOF

sudo testparm -s 2>&1

sudo systemctl enable --now smbd
sudo systemctl restart smbd
sudo systemctl status smbd --no-pager
