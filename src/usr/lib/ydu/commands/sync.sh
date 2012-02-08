#! /usr/bin/env bash

set -eu

rsync_dirs=( )
rsync_dst=( )

conf_add_to_rsync() {
	if [[ ${#rsync_dirs} -eq 0 ]] ; then
		rsync_dirs=( $1 )
		rsync_dst=( $2 )
	else
		rsync_dirs=( ${rsync_dirs[@]} $1 )
		rsync_dst=( ${rsync_dst[@]} $2 )
	fi
}

step_rsync() {
	local last
	last=$((${#rsync_dirs[@]}-1))
	for i in `seq 0 1 $last` ; do
		src=${rsync_dirs[$i]}
		dst=${rsync_dst[$i]}
		rsync -av --delete --exclude=.git $src $remote_usr@$remote:$dst
	done
}

main() {
	source $HOME/.config/ydu/sync.sh

	conf_$1
	step_rsync
}
