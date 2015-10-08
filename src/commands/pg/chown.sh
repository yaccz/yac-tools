#! /bin/sh


usage() {
	echo "$0 <pg_dump> <src_owner> <dst_owner>"
	exit 1
}

main() {
	test ${#@} -eq 3 || usage

	test -f ${1} || (echo "${1} not a file" && exit 1)

	sed -i "s/^ALTER \(.*\) OWNER TO ${2};$/ALTER \1 OWNER TO ${3};/" ${1}
}
