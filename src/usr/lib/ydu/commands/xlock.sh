#! /bin/bash

set -eu

usage() {
	echo "Usage: $0     # lock screen"
}

main() {
	if `pgrep -f kdeinit > /dev/null`; then
		/usr/lib64/kde4/libexec/kscreenlocker --forcelock
		return
	fi
}

