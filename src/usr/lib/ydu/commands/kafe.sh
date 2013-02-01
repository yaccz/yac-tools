#! /usr/bin/env bash

set -eu


main() {
	sleep $((3*60)) && echo "KAFE" | dzen2 -fg red -p 1000
	sleep $((1*60)) && echo "KAFE" | dzen2 -fg red -p 1000
}
