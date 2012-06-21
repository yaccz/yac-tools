#! /bin/bash

. $HOME/.local/share/ydu/months.sh

usage() {
	echo "display months cheatsheet with highlighted current month"
}

main() {
	cat $MONTHS_PATH | ack --pass `date +%b`
}
