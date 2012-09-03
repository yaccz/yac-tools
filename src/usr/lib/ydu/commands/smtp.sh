#! /usr/bin/env bash

set -eu

usage() {
	echo "Usage: $0 smtp auth plain <user> <pwd>"
}

main() {
	if [ ! $# -eq 4 ] ; then
		usage
		return 1
	fi

	if [ ! "$1" == "auth" ] ; then
		usage
		return 1
	fi


	if [ ! "$2" == "plain" ] ; then
		usage
		return 1
	fi

	local usr pass


	usr=$3
	usr=`echo $usr | sed 's/@/\\\\@/g'`
	pass=$4

	perl -MMIME::Base64 -e 'print encode_base64("\000'$usr'\000'$pass'")'
}
