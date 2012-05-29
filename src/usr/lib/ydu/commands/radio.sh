#! /usr/bin/env bash

set -eu

die() {
	echo $@
	exit 1
}

usage() {
	echo "Usage: <radio_to_play>"
}

main() {
	local radio line

	radio=$1
	source $HOME/.config/ydu/radio.sh

	line=`cat $RADIO_DATA | grep -E "^$radio\|"` || die "no such radio defined"
	line=`echo $line | sed 's/^.*|\(.*\)$/\1/'`
	echo "playing $line"
	$RADIO_PLAYER $line
}
