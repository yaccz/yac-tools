#! /bin/sh

null_to_lf() {
    sed 's/\x00/\n/g'
}

trans=( null_to_lf )

usage() {
    echo "Usage: $0 <named_transofrmation>"
    echo "Available <named_transofrmation>:"
    for i in ${trans[@]}; do
        echo -e "  ${i}"
    done
}

main() {
    for i in ${trans[@]}; do
        [ "${i}" = "${1}" ] && { $1; return; }
    done

    usage ; return 1
}
