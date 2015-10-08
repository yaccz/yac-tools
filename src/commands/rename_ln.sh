#!/bin/sh

usage() {
	echo "rename_ln <from> <to> [<file>]"
	echo "detailed info at http://stackoverflow.com/questions/11456588/is-there-a-simple-way-to-batch-rename-symlink-targets"
}

main() {
	if [ $# -lt 3 ]; then
		usage
		exit 1
	fi

	local from to

	from="$1"
	to="$2"

	shift 2
	for i; do
		a=$(readlink "$i") && ln -sf "$(echo $a | sed "s@$from@$to@")" "$i"
	done
}
