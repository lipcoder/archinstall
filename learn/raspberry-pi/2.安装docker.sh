sudo install -m 0755 -d /etc/apt/keyrings

# 1) 导入 Docker 官方 GPG Key（用它来校验包签名）
curl -fsSL https://download.docker.com/linux/debian/gpg |
	sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 2) 写入清华 Docker CE 源
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
