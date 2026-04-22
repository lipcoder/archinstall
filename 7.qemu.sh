qemu-img create -f qcow2 ~/vm/ubuntu-server.qcow2 80G

mv ~/vm/ubuntu-server.qcow2 ~/vm/ubuntu-server-base.qcow2                               # 备份
qemu-img create -f qcow2 -b ~/vm/ubuntu-server-base.qcow2 ~/vm/ubuntu-server-work.qcow2 # 基于这个基底创建一个新盘

qemu-system-x86_64 \
	-enable-kvm \
	-m 4096 \
	-smp 2 \
	-cpu host \
	-drive file=$HOME/vm/ubuntu-server.qcow2,format=qcow2 \
	-netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::3000-:3000,hostfwd=tcp::8080-:8080 \
	-device virtio-net-pci,netdev=n1

ssh -p 2222 pi@127.0.0.1

qemu-system-x86_64 \
	-enable-kvm \
	-m 4096 \
	-smp 2 \
	-cpu host \
	-drive file=$HOME/vm/ubuntu-server.qcow2,format=qcow2 \
	-cdrom $HOME/iso/ubuntu-24.04.4-live-server-amd64.iso \
	-boot d \
	-netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::3000-:3000,hostfwd=tcp::8080-:8080 \
	-device virtio-net-pci,netdev=n1
