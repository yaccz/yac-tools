#! /bin/sh

# {{{ User configurable settings
REPETITIONS=${REPETITIONS:-5}
EXTRA_DD_ARGS=${EXTRA_DD_ARGS:-"conv=fdatasync oflag=dsync"}
# }}}

# {{{ Fixes settings

# BS COUNT BS COUNT ...
config="512 1000000 1024 500000 2048 250000 4096 125000 8192 62500"
IF=/dev/zero
OF=/tmp/crap

# }}}

# .. Rest of the code

declare -a _EXTRA_DD_ARGS
_EXTRA_DD_ARGS=( $EXTRA_DD_ARGS )

bench_one() {
	local bs count
	bs=$1
	count=$2

	for i in `seq 0 $REPETITIONS`; do
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

main() {
	for i in REPETITIONS EXTRA_DD_ARGS; do
		echo "$i=${!i}"
	done

	for i in ${_EXTRA_DD_ARGS[@]}; do
		export _EXTRA_DD="$i"
		bench $config
	done
}
