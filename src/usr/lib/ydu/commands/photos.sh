#! /usr/bin/env bash

set -eu

assert_prerun() {
	which convert >/dev/null || (echo "Missing ImageMagick" ; exit 1)
}

main() {
	# argv = dirs
	assert_prerun

	local pwd_orig
	pwd_orig=`pwd`

	for i in $@; do
		cd $i
		mkdir orig
		mv *JPG orig
		cp orig/* ./
		for i in *JPG; do
			convert -resize 25% $i $i;
		done

		cd $pwd_orig
	done
}
