sudo apt update
sudo apt install -y samba

sudo tee /etc/samba/smb.conf >/dev/null <<'EOF'

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
   path = /data/data
   browseable = yes
   read only = no
   guest ok = yes
   force user = aria

EOF

sudo testparm -s 2>&1 || exit 1

sudo systemctl enable --now smbd

sudo systemctl status smbd --no-pager