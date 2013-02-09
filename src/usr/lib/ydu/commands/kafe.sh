#! /usr/bin/env bash

set -eu


main() {
	wait_=0
	while getopts w: name
	do
		case $name in
			w) wait_=$OPTARG;;
			?) usage
		esac
	done

	shift $((OPTIND - 1))

	sleep ${wait_}m && echo "KAFE" | dzen2 -fg red -p 1000
}
