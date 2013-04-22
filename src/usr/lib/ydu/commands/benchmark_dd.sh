#! /bin/sh

# BS COUNT BS COUNT ...
config="512 1000000 1024 500000 2048 250000 4096 125000 8192 62500"
IF=/dev/zero
OF=/tmp/crap

declare -a EXTRA_DD_ARGS
EXTRA_DD_ARGS=( "conv=fdatasync" "oflag=dsync" )

bench_one() {
	local bs count
	bs=$1
	count=$2

	for i in {0..5}; do
		set -x
		time dd if=$IF of=$OF bs=$bs count=$count $_EXTRA_DD;
		set +x
	done
}

bench() {
	local bs count

	while [ $# -gt 0 ]; do
		bs=$1
		shift
		count=$1
		shift

		bench_one $bs $count
	done
}

for i in ${EXTRA_DD_ARGS[@]}; do

	export _EXTRA_DD="$i"
	bench $config
done
