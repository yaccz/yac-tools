#! /bin/bash

. $HOME/.local/share/yt/months.sh

usage() {
	echo "display months cheatsheet with highlighted current month"
}

main() {
	cat $MONTHS_PATH | ack --pass `date +%b`
}
