#! /bin/sh

usage() {
	echo "Usage: ./$0";
}

main() {
	local promises tmp

	promises='body common control { bundlesequence => { a }; } bundle agent a { reports: linux:: "${sys.key_digest}"; }'
	tmp=`mktemp`
	echo $promises > $tmp
	cf-agent -f $tmp;
	rm $tmp
}
