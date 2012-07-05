#! /usr/bin/env bash

usage() {
	echo "Usage: $0 message to write"
}

main() {
	if [ $# == 0 ] ; then
		echo "no message given" ; exit 1
	fi

	. ~/.config/ydu/work/log.sh

	local date_
	date_=`date '+%Y-%m-%d %H:%M:%S'`
	echo "$date_ $@" >> $YDU_WORK_LOG_FILENAME
}
