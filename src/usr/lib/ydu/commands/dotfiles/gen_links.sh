#! /bin/sh

set -eu

ylg=/usr/lib/ylg.sh
if [ -f $ylg ] ; then
	. $ylg
	ylg setLevel info
	ylg on debug && set -x
else
	ylg() { return 0; }
fi

link_it() {
	cd ./build/home
	ln -snf $1 $2
	cd ../..
}

main() {
	local links src dst

	build_dir=$1

	for i in `find ${build_dir}/config/xdg_emu  -maxdepth 1 -type d`; do

		links=$i/__links
		[ ! -f $links ] && continue

		cat $links | while read j ; do
			src=`echo "$j" | cut -f 1 -d "	"`
			dst=$i/`echo "$j" | cut -f 2 -d "	"`
			# ^ both relative to $HOME

			dst=`echo $dst | sed 's/^.\/\/build\//./'`

			ylg lg info "src: $src"
			ylg lg info "dst: $dst"

			link_it $dst $src
		done
		rm $links
	done
}
