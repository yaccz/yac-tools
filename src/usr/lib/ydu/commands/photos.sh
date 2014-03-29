#! /usr/bin/env bash

set -u

usage() {
	echo "Copy originals to separate dir and create standard smaller pictures for public release"
}

assert_prerun() {
	which convert >/dev/null || (echo "Missing ImageMagick" ; exit 1)
}


find_work_pics() {
	find ./ -maxdepth 1 -type f -iname '*.jpg' $@
}

main() {
	# argv = dirs
	assert_prerun

	for i in $@; do
		pushd $i >/dev/null || return
		mkdir orig || return
		find_work_pics -exec mv {} orig/ \; || return
		cp orig/* ./ || return
		find_work_pics -exec convert -resize 25% {} {} \; || return

		popd >/dev/null || return
	done
}
