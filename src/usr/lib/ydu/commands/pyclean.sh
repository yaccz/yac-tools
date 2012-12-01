#! /usr/bin/env bash

set -eu

usage() {
	echo ""
}

main() {
	while ! test -d .git ; do
		cd ..
	done

	find -name '*.pyc' -delete
}
