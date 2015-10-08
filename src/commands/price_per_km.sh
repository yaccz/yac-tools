#! /bin/bash

usage() {
	echo "$0 price_per_km price_per_liter consumption_per_100"
}

main() {
	if [ $# -lt 2 ]; then
		usage
		exit 1
	fi

	local price consumption
	price=$1
	consumption=$2

	echo "$price $consumption 0.01 * * p" | dc
}