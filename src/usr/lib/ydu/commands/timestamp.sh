#! /usr/bin/env bash

usage() {
	echo "show timestamp in human readable form"
}

main() {
	date -d@$1 '+%Y-%m-%d %H:%M:%S'
}
