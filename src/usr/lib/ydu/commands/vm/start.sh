#! /usr/bin/env bash

start_() {
	echo "    vnc: ${VNC}"

	if [[ ! "${USB_PASS:-}" == "" ]] ; then
		# USB_PASS shall be "vendorid=X,productid=Y"
		USBARG="-usb -device usb-host,${USB_PASS}"
	else
		USBARG=""
	fi

	if [[ ! "${BOOT:-}" == "" ]] ; then
		BOOTARG="-boot ${BOOT}"
	else
		BOOTARG=""
	fi

	kvm \
		-drive file=${HDA},if=virtio \
		${USBARG} \
		${BOOTARG} \
		-net nic,macaddr=${MAC},model=virtio \
		-net tap,ifname=${TAP},script=no,downscript=no \
		-m ${MEM} \
		-vnc ${VNC}
}

main() {
	source ~/.config/ydu/vm/start.sh

	echo "starting VPS $1"
	def_$1
	start_ &
}
