#! /usr/bin/env bash

set -eu

die() {
	echo $@
	exit 1
}

usage() {
	echo "Usage: $0 [-l] <radio_to_play>"
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
	source $HOME/.config/yt/radio.sh

	while getopts lh name
	do
		case $name in
			l) list; return 0;;
			h) usage; return 0;;
			?) usage; return 1;;
		esac
	done

	shift $((OPTIND - 1))

	if [ $# -lt 1 ]; then
		usage
		return 1
	fi

	play $@
}
