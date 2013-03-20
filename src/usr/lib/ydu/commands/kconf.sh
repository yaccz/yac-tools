#! /bin/sh

usage() {
	echo "$0 -e <config_file> [<option>]"
	echo " kernel config"
	echo " option is without CONFIG_ prefix"
}

_enable() {
	sed -i 's:# CONFIG_'$2' is not set:CONFIG_'$2'=y:g' $1
}

main() {
	if [ ! "$1" == "-e" ] ;then
		echo "Only -e is supported atm" > &2
		exit 1
	fi

	shift

	local cfg
	cfg=$1
	shift

	if [ ! -f $cfg ] ; then
		echo $cfg "ENOTAFILE"
		exit 2
	fi

	for i in $@; do
		_enable $cfg $i
	done
}