#! /usr/bin/env bash

set -eu

has_key() {
	echo "${1}" | grep -E "(^| )${2}( |$)" >/dev/null 2>&1
}

main() {
	source $HOME/.config/ydu/km.sh

	keys=${!maps[@]}

	if [ ${#} = 0 ] ; then
		echo "Keymaps: $keys"
		return 0
	fi

	if has_key "${keys}" ${1} ; then
		setxkbmap ${maps[${1}]}
	else
		echo "Do not know keymap ${1}"
		return 1
	fi
}
