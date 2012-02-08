#! /usr/bin/env bash

start_() {
	echo "    vnc: ${VNC}"
	kvm \
		-drive file=${HDA},if=virtio \
		-net nic,macaddr=${MAC},model=virtio \
		-net tap,ifname=${TAP},script=no,downscript=no \
		-m ${MEM} \
		-vnc ${VNC} \
}

main() {
	source ~/.config/ydu/vmstart.sh

	echo "starting VPS $1"
	def_$1
	start_ &
}
