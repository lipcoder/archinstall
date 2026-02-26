docker run --rm -it \
	--name=face1 \
	--platform linux/arm64 \
	--device=/dev/video0 \
	--mount type=bind,source="$HOME/project",target=/data \
	--network host \
	ubuntu:24.04 \
	/bin/bash

# -i 表示保持运行
# -t 表示分配一个终端来运行并立即进入
# -it表示创建时自动进入，退出后容器自动关闭，被称为交互式容器
# -d 表示创建一个容器不会立即进入
# -id表示创建容器，在后台运行，需要docker exec进入容器，退出后不会立即关闭，被称为守护式容器

# --rm是退出当前容器后容器自动销毁
# --name是命名该docker
# --device=/dev/video0 把宿主机的摄像头映射进容器
# --mount type=bind,...外挂数据卷
# --network host 用宿主机网络
# --platform linux/arm64 跨架构编译或者运行
# 所有 --xxx 选项都放在镜像名 ubuntu-arm64:24.04 之前

# ==========================================================================

docker ps                    # 查看容器 -a查看所有,-aq所有容器的id
docker exec -it c2 /bin/bash # 进入c2这个容器
docker stop c2               # 关闭守护式容器c2
docker rm c2                 # 删除容器
docker rm 'docker ps -aq'    # 删除所有容器
docker inspect c2            # 容器信息
docker cp 路径 容器id+路径         # 不挂载数据卷的情况下向容器内传输文件（文件夹则加-r）

docker pull ubuntu
#加上:版本，也可以不加,自动选择最新版本
# --platform=linux/arm64 选择架构
docker tag ubuntu:24.04 ubuntu-arm64:24.04 # 将这个镜像换一个tag，防止拉取同名不同架构的镜像出现none报错
docker rmi ubuntu:24.04                    # 删除这个旧标签
docekr images                              # 查看当前有哪些docker镜像

# ===========================================================================

sudo pacman -S qemu-user-static-binfmt # qemu跨架构运行
sudo systemctl enable --now systemd-binfmt.service

docker save -o ubuntu24_arm64.tar ubuntu:24.04                         # 打包成 tar
docker load -i ubuntu24_arm64.tar                                      # 加载镜像
docker image inspect ubuntu:24.04 --format '{{.Os}}/{{.Architecture}}' # 查看镜像的架构
docker commit face face_recog:pi5                                      # 打包成镜像
docker tag face_recog:pi5 face_recog:pi5-v1                            # 更换tag标签
