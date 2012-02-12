#! /usr/bin/env bash

set -eu


main() {
	source $HOME/.config/ydu/maildir/shownew.sh

	msg="New mail :: "
	list=`mktemp`

	ls $maildir > $list

	while read i; do
		new=`ls "$maildir/$i/new" | wc -l`
		if [[ $new -eq 0 ]] ; then
			continue
		fi

		msg="${msg}$i: $new  "
	done < $list

	rm $list

	if [[ ${#msg} -eq 12 ]] ; then
		return 0
	fi

	echo $msg | dzen2 -p 10 -ta l &
}
