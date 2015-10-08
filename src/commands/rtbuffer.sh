#! /bin/sh

usage() {
    echo "Usage: $0 <command> <host>"
    echo "Remote Tmux Buffer"
    echo ""
    echo "commands:"
    echo "  s (send)"
    echo "     sends stdin to <host> tmux buffer"
    echo "     example:"
    echo "       cat file | $0 s perun"
    echo "       xsel -b | $0 s perun"
    echo ""
    echo "  g (g)"
    echo "    receives tmux buffer from <host> and outputs to stdout"
    echo "    example:"
    echo "      $0 g perun | xsel -b"
}

main() {
    [ $# -eq 0 ] && { usage; return 1; }

    local local_f remote_f host command_
    host="${2}"
    command_="${1}"
    local_f=/tmp/rtbuffer
    remote_f=${local_f}

    case $command_ in
        s)
            cat > ${local_f}
            scp ${local_f} $host:${remote_f}
            ssh "${host}" "tmux load-buffer ${remote_f}"
            ;;

        g)
            ssh "${host}" "tmux show-buffer"
            #tmux load-buffer ${local_f}
            ;;

        *)
            usage; return 1;
    esac
}
