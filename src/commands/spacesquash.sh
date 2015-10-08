#! /usr/bin/env bash

usage() {
	echo ""
}

main() {
	local replacer
	replacer='\t'

	while getopts s name
	do
		case $name in
			s) replacer=' ';;
			?) usage
		esac
	done

	shift $((OPTIND - 1))

	while read i; do
		echo $i | sed 's/\s\+/'"$replacer"'/g'
	done
}