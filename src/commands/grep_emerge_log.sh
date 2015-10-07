#! /bin/sh

usage() {
	echo "cat emerge.log | $0"
	echo "Grep emerge.log for emerged packages"
}

main() {
	while read line; do
	echo $line | grep Merging | sed 's/^.*Merging (\([a-zA-Z0-9-]\+\/[a-zA-Z0-9.-]\+\).*$/\1/'
	done
}
