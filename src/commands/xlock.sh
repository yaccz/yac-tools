#! /bin/bash

set -eu

usage() {
	echo "Usage: $0     # lock screen"
}

main() {
	if `pgrep -f xscreensaver > /dev/null` ; then
		xscreensaver-command -lock
		return
	fi

	if `pgrep -f kdeinit > /dev/null`; then
		/usr/lib64/kde4/libexec/kscreenlocker --forcelock
		return
	fi

	xscreensaver -no-capture-stderr -verbose -log $HOME/.local/xscreensaver.log &
	yt xlock
}

