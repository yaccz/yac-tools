#! /usr/bin/env bash

set -eu

die() {
	echo $@
	exit 1
}

usage() {
	echo "Usage: <radio_to_play>"
}

play() {
	local radio line index
	local -a lines

	radio=$1
	index=${2:-0}

	line=`cat $RADIO_DATA | grep -E "^$radio\|"` || die undefined radio
	lines=( `echo ${line#*|} | sed 's/|/ /g'` )

	[[ $index -ge ${#lines[@]} ]] && die undefined index
	[[ -z "${#lines[$index]}" ]] && die undefined value

	echo "playing ${lines[$index]}"
	$RADIO_PLAYER ${lines[$index]}
}

list() {
	local lines indexes
	lines=`cat $RADIO_DATA`
	for i in $lines; do
		indexes=$(( `echo $i | sed 's/[^|]//g' | wc -c`-1 ))
		echo $indexes ${i%%|*}
	done
}

main() {
	source $HOME/.config/ydu/radio.sh

	if [[ $1 == "ls" ]] ; then
		list
	else
		play $@
	fi
}
