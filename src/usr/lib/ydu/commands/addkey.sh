#! /bin/sh

# FIXME: needs testing and debug

main() {

    key=`cat ~/.ssh/id_rsa.pub`
    rcmd='
        d=${HOME}/.ssh; [ ! -d $d ] && { mkdir $d; chmod 700 $d; };
        d=$d/authorized_keys; [ ! -f ] && { touch $d; chmod 700 $d; };
        echo "${key}" >> $d
    '

    ssh $1 -c $rcmd
}
