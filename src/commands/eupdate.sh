#! /usr/bin/env bash

set -u

main() {
	local ec
	ec=1
	while [ $ec -eq 1 ]; do
		ec=0
		emerge -uNDv world
		ec=$(($ec || $?))
		revdep-rebuild
		ec=$(($ec || $?))
		haskell-updater --all
		ec=$(($ec || $?))
		perl-cleaner --reallyall
		ec=$(($ec || $?))
		echo "ec: $ec"
	done
}