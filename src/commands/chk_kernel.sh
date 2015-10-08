#! /bin/sh

set -eu

usage() {
	echo "Usage: $0 <group-to-check>"
}

main() {
	. ~/.config/yt/chk_kernel.sh

	opts_$1
	shift

	for i in ${OPTS[@]}; do
		grep "$i[ |=]" $CONFIG || echo "$i not found"
	done
}
