#! /bin/sh

# {{{ User configurable settings
REPETITIONS=${REPETITIONS:-5}
# }}}
# {{{ Fixes settings

# BS COUNT BS COUNT ...
IF=/tmp/crap
OF=/dev/null
# }}}

# .. Rest of the code
bench_one() {
	for i in `seq 0 $REPETITIONS`; do
		set -x
		time dd if=$IF of=$OF;
		set +x
	done
}

main() {
	for i in REPETITIONS; do
		echo "$i=${!i}"
	done

	dd if=/dev/zero of=$IF bs=2048 count=250000 # prep input file
	bench_one
}
