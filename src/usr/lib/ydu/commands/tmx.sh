#! /usr/bin/env bash

set -eu

main() {
	local name
	name=$1

	if tmux ls | grep -E "^$name:" >/dev/null ; then
		tmux at -t $name
	else
		tmux_sess_$name
	fi
}

tmux_sess_0() {
	name=0
	tmux new-session -s $name 'unset TMUX; tmux' \; \
		rename-window wl \; \
		new-window -n media 'unset TMUX; tmux' \; \
		new-window -n cheatsheets 'unset TMUX; cd data/yaccz/cheatsheets/src; tmux'
}

tmux_sess_srv-dev() {
	name=srv-dev
	tmux new-session -s $name
}

tmux_sess_srv-pro() {
	name=srv-pro
	tmux new-session -s $name
}
