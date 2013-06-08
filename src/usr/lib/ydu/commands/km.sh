#! /usr/bin/env bash

set -eu

has_key() {
	echo "${1}" | grep -E "(^| )${2}( |$)" >/dev/null 2>&1
}

usage() {
	echo "Usage: $0 <command> <command_args>

Commands:
=========
* t - toggle
* s - set

set
===
:Syntax: $0 s [<keymap_code>]

If <keymap_code> is not given, space separated list of available <keymap_code> will be printed.

keymap_code are defined in XDG_CONFIG_HOME/ydu/km.sh

toggle
======
For toggle to work, <keymap_code> must be a substring of value of field layout:  printed by "'`setxkbmap -query`'" for given language"

# NOTE: eg. cz layout prints value "cz,"
}

cmd_set() {
	keys=${!maps[@]}

	if [ ${#} = 0 ] ; then
		echo "$keys"
		return 0
	fi

	if has_key "${keys}" ${1} ; then
		setxkbmap ${maps[${1}]}
	else
		echo "Do not know keymap ${1}"
		return 1
	fi
}

cmd_toggle() {
	local current next
	current=$(setxkbmap -query | grep layout: | sed 's/ \+/ /g' | cut -f2 -d" ")

	next=false

	for j in 1 2; do
		# this j-loop is for wrapping around when `current` is last from `maps` so we get to set the first one
		for i in ${!maps[@]}; do
			if $next; then
				echo "setting keymap: $i" | dzen2 -sa c -p 1 &
				cmd_set $i
				return 0
			fi

			if `echo $current | grep -q $i`; then
				# NOTE: read usage() code first
				next=true
			fi
		done
	done
}

main() {
	source $HOME/.config/ydu/km.sh

	local cmd
	case $1 in
		t) cmd="toggle";;
		s) cmd="set";;
		?) usage
	esac

	shift 1

	cmd="cmd_$cmd"
	$cmd $@
}
