#! /usr/bin/env bash

set -eu

usage() {
	echo "Usage: $0 <file>"
	echo "unpacks .deb package, TODO: rpm"
}

unpack() {
	case $1 in
		*.deb) unpack_deb $1 ;;
		*.rpm) unpack_rpm $1 ;;
		*)
			echo "i dont know $1"
	esac
}

unpack_rpm() {
	local dir
	dir=${1%.rpm}

	mkdir $dir
	cp $1 $dir
	cd $dir
	rpm2cpio $1 | cpio -idmv
	# ^ this extracts just the CONTENTS.cpio from the rpm,
	# not the accompanying INFO, HEADER, INSTALL, UPGRADE files
}

unpack_deb() {
	local dir
	dir=${1%.deb}

	mkdir $dir
	cp $1 $dir
	cd $dir
	ar x $1
	mkdir data
	tar -xf data.tar.gz -C data/
	mkdir control
	tar -xf control.tar.gz -C control/
}

main() {
	if [ ${#} = 0 ] ; then
		usage
		return 1
	fi

	unpack $1
}
