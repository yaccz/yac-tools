#! /usr/bin/env bash

set -eu

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

	local pwd_orig find_cmd
	pwd_orig=`pwd`


	for i in $@; do
		cd $i
		mkdir orig
		find_work_pics -exec mv {} orig/ \;
		cp orig/* ./
		find_work_pics -exec convert -resize 25% {} {} \;

		cd $pwd_orig
	done
}
