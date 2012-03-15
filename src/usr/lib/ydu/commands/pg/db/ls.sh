#! /bin/sh

usage() {
	echo "Usage: $0 -e <db>[,<db>]"
	echo "lists databases"
	echo " -e for exclusion"
	exit 1
}

main() {
	local exclude

	while getopts e: name
	do
		case $name in
			e) exclude=`echo "$OPTARG" | sed 's/,/|/g'`;;
			?) usage
		esac
	done

	shift $((OPTIND - 1))

	local ls
	dbs=`psql -lt | cut -d " " -f 2 | sed '/^$/d'`

	if [ "${exclude:-}" = "" ] ; then
		echo "$dbs"
		return
	fi

	echo "$dbs"  | grep -vE "^(${exclude})$"
}
