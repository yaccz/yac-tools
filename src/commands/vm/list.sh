#! /usr/bin/env bash

main() {
	source ~/.config/yt/vm.sh

	for i in $vms; do
		echo $i
	done
}
