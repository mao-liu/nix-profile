#!/bin/bash

IFS=$'\n'

if [[ $# -gt 0 ]]; then
    script=$1
    shift
    if [[ ! -e $script ]]; then
        echo "File not found: $script" >&2
        exit
    fi
    args=$@
else
    echo "Must specify the script to run" >&2
    exit
fi

function green_text {
    echo -e "\033[92m$@\033[39m"
}
function red_text {
    echo -e "\033[91m$@\033[39m"
}

function run_remote {
    remote=$1
    shift
    script=$1
    shift
    args=$@

    tmp=`ssh $remote 'mktemp "${TMPDIR-/tmp}/tmp.XXXXXXXXXX"'`
    if [[ ! $? -eq 0 ]]; then
        return 1
    fi
    scp $script $remote:$tmp 2>&1 >/dev/null
    if [[ ! $? -eq 0 ]]; then
        return 1
    fi
    ssh -t $remote bash -c "'
        source ~/.bash_profile;
        chmod u+x $tmp;
        $tmp $args;
        rm $tmp;
        '"
    if [[ ! $? -eq 0 ]]; then
        return 1
    fi
    return 0
}

for l in `cat my_computers`; do

    comp=${l%%#*}
    if [[ ${#comp} -gt 0 ]]; then

        user=`echo $comp | tr -s ' ' | cut -d ' ' -f 1`
        host=`echo $comp | tr -s ' ' | cut -d ' ' -f 2`

        echo -e "################################"
        echo -e "#\t${user}@${host}"
        echo -e ""
        run_remote ${user}@${host} $script $args
        echo -e ""
        if [[ $? -eq 0 ]]; then
            green_text "#\t${user}@${host}:\tsuccess"
        else
            red_text "#\t${user}@${host}:\tfailed"
        fi
    fi
done

