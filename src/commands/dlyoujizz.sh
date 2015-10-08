#! /bin/sh

DATA_DIR=$HOME/.local/share/yt/dlyoujizz

_curl() {
	EXTRA_ARGS=""
	#EXTRA_ARGS="-v"
	set -x
	#curl $EXTRA_ARGS -c $DATA_DIR/cookie.jar $@
	curl $EXTRA_ARGS $@
	set +x
}

dl() {
	name=`echo $1 | sed 's/.*\/\([a-zA-Z0-9-]*\)\.html/\1/'`.flv
	if [ -f $name ] ; then
		echo "$name already exists"
		return 1
	fi

	url1=`_curl $1 | grep "<iframe src=" | grep videos/embed | sed 's#.*\(http:.*youjizz.com/videos/embed/[0-9]\+\).*#\1#' | sort -u`
	flv=`_curl $url1 | grep so.addVariable\(\"file | sed 's/.*"\(http:.*flv.*\)").*/\1/'`

	#_curl $flv -o $name
	wget $flv -O $name
}

usage() {
	echo "Usage: $0 <uri>[ <uri>]"
	echo "       $0 -c <uri>[<uri>]"
	echo "Downloads youjizz.com videos."
}

split_uris() {
	echo $1 | sed 's/\([^ ]\)http:\/\//\1 http:\/\//g'
}

main() {
	local cm=1; # convenient_multitasking if you know what i mean ;)

	if [ "$1" = "-c" ] ; then
		cm=0;
		shift
	fi

	for i in $@ ; do
		if [ $cm -eq 0 ] ; then
			(return $cm) && i=`split_uris $i` || true
			for j in $i; do
				dl "$j" || true
			done
		else
			dl "$i" || true
		fi
	done
}
