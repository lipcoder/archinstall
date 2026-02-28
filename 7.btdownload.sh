sudo apt update
sudo apt install -y qbittorrent-nox

cat > /etc/systemd/system/bt.service <<'EOF'

[Unit]
Description=bt (qBittorrent-nox headless)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=aria
Group=aria

WorkingDirectory=/data/data
Environment=HOME=/data/data

ExecStart=/usr/bin/qbittorrent-nox --webui-port=18080

Restart=on-failure
RestartSec=3
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target

EOF

if ! sudo systemctl daemon-reload; then
  echo "daemon-reload failed" >&2
  exit 1
fi

sudo systemctl enable --now bt.service
sudo systemctl status bt.service
