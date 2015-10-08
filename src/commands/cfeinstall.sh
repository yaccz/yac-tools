#! /usr/bin/env bash

set -eu

rsync_dirs=( )
makefiles=""

conf_add_to_rsync() {
	if [[ ${#rsync_dirs} -eq 0 ]] ; then
		rsync_dirs=( $1 )
	else
		rsync_dirs=( ${rsync_dirs[@]} $1 )
	fi
}
conf_add_to_makes() {
	makefiles="$makefiles $1"
}

#######
ns=/root/cfeinstalls

step_rsync() {
	ssh root@$remote "mkdir $ns || true"

	for i in ${rsync_dirs[@]} ; do
		rsync -av --delete --exclude=.git $i root@$remote:$ns/`basename $i`
	done
}

step_install() {
	for i in $makefiles ; do
		ssh root@$remote "cd $ns && cd $i && (make clean || true) && make && make install"
	done
}

main() {
	source $HOME/.config/yt/cfeinstall.sh

	conf_$1
	step_rsync
	step_install

	echo "cfeinstall $1 done" | dzen2 -p 1 -ta c -y 300 -fg red &
}
