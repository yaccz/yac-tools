#! /bin/sh

usage() {
	echo ""
}

BASEDIR="/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight/"

_show_max_brightness() {
	echo "max_brightness: $(cat $BASEDIR/max_brightness)"
}


_set_brightness() {
	echo $1 > $BASEDIR/brightness
}

main() {
	if [ $# -eq 0 ] ; then
		_show_max_brightness
	else
		_set_brightness $1
	fi
}
