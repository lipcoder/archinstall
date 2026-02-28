cat >>$HOME/.bashrc <<'EOF'
screenoff() {
  sudo openvt -f -c 1 -- setterm --blank 0 \
  && sudo openvt -f -c 1 -- setterm --blank 1 \
  && sudo chvt 2 && sudo chvt 1
}
EOF

screenoff
