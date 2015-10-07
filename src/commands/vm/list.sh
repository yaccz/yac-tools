#! /usr/bin/env bash

main() {
	source ~/.config/ydu/vm.sh

	for i in $vms; do
		echo $i
	done
}
