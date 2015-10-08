#! /bin/bash

set -eu

usage() {
	echo "Usage: $0     # pritn current identify"
	echo " $0 <id_name> # set preconfigured identity to local repo"
}

main() {
	# manage git identities
	source $HOME/.config/yt/git.sh

	if [ $# -eq 0 ]; then
		# just display current identity
		git config user.name
		git config user.email
		return
	else
		# switch identity
		local tmp
		tmp="id_${1}_name"
		git config user.name "${!tmp}"
		tmp="id_${1}_email"
		git config user.email ${!tmp}
		return
	fi

	return 1
}

