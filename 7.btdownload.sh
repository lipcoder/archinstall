#!/usr/bin/env bash
set -euo pipefail

WORKDIR="/data/data"
PORT="18080"

SERVICE_USER="${SUDO_USER:-$(id -un)}"
SERVICE_GROUP="$(id -gn "$SERVICE_USER")"

echo "开始下载"
sudo apt-get install -y qbittorrent-nox

echo "确保文件夹"
sudo mkdir -p "$WORKDIR"
sudo chown -R "$SERVICE_USER:$SERVICE_GROUP" "$WORKDIR"

echo "创建system配置文件"
sudo tee /etc/systemd/system/bt.service >/dev/null <<EOF
[Unit]
Description=bt (qBittorrent-nox headless)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=${SERVICE_USER}
Group=${SERVICE_GROUP}

WorkingDirectory=${WORKDIR}
Environment=HOME=${WORKDIR}

ExecStart=/usr/bin/qbittorrent-nox --webui-port=${PORT}

Restart=on-failure
RestartSec=3
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now bt.service
sudo systemctl status --no-pager bt.service