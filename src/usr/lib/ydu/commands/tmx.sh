#! /usr/bin/env bash

set -eu

main() {
	source ~/.config/ydu/tmx.sh
	# this file defines the needed tmux_sess_<name> functions to setup the required tmux instances
	local name
	name=$1

	if tmux ls | grep -E "^$name:" >/dev/null ; then
		tmux at -t $name
	else
		tmux_sess_$name
	fi
}

