#! /usr/bin/env bash

set -eu

usage() {
	echo "Usage: $0 changelog_path"
}

get_field() {
	local field
	field=$2
	dpkg-parsechangelog -l$1 -c1 |grep $field | sed "s/^$field: //"
}

main() {
	local version changelog version pkg_name urgency distribution

	changelog=$1
	if [ ! -f $changelog ]; then
		touch $1
	fi

	if [ `cat $changelog | wc -l` -eq 0 ]; then
		version=0.0.1~dev
		urgency=medium
		distribution=stable
		pkg_name="<pkg name>"
	else
		version=`get_field $changelog Version`
		pkg_name=`get_field $changelog Source`
		urgency=`get_field $changelog Urgency`
		distribution=`get_field $changelog Distribution`
	fi

msg="${pkg_name} ($version) $distribution; urgency=$urgency

  <log>

 -- ${DEBFULLNAME} <${DEBEMAIL}>  `date -R`
"
	w=$changelog
	(tmpfile=`mktemp` && { echo "$msg" | cat - $w > $tmpfile && mv $tmpfile $w; } )
	vim $changelog
}
