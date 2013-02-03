#! /usr/bin/env bash

start_() {
	echo "    vnc: ${VNC}"

	if [[ -n "${USB_PASS:-}"  ]] ; then
		# USB_PASS shall be "vendorid=X,productid=Y"
		USBARG="-usb -device usb-host,${USB_PASS}"
	fi

	if [[ -n "${BOOT:-}" ]] ; then
		BOOTARG="-boot ${BOOT}"
	fi

	if [[ -n "${MAC:-}" && -n "${TAP:-}" ]] ; then
		NETARG="-net nic,macaddr=${MAC},model=virtio"
		NETARG="$NETARG -net tap,ifname=${TAP},script=no,downscript=no"
	fi

	if [[ -n "${HDA:-}" ]] ; then
		HDAARG="-drive file=${HDA},if=virtio"
	fi

	if [[ -n "${DRIVE:-}" ]] ; then
		DRIVEARG="-drive ${DRIVE}"
	fi

	if [[ -n "${CPU:-}" ]] ; then
		CPUARG="-cpu kvm64"
	fi

	qemu-kvm \
		${HDAARG:-} \
		${DRIVEARG:-} \
		${USBARG:-} \
		${BOOTARG:-} \
		${NETARG:-} \
		${KVM_ADD_ARG:-} \
		${CPUARG:-} \
		-m ${MEM} \
		-vnc ${VNC}
}

main() {
	source ~/.config/ydu/vm/start.sh

	echo "starting VPS $1"
	def_$1
	start_ &
}
