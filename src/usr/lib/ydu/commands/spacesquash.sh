#! /usr/bin/env bash

main() {
	while read i; do
		echo $i | sed 's/\s\+/\t/g'
	done
}
