#!/bin/bash

IFS=$'\n'

if [[ $# -gt 0 ]]; then
    remote=$1
fi

for l in `cat my_computers`; do

    comp=${l%%#*}
    if [[ ${#comp} -gt 0 ]]; then

        user=`echo $comp | tr -s ' ' | cut -d ' ' -f 1`
        host=`echo $comp | tr -s ' ' | cut -d ' ' -f 2`

        if [[ ${#remote} -eq 0 ]]; then
            echo "=============="
            echo "${user}@${host}"
            scp my_computers $user@$host:~/
            scp ./$0 $user@$host:~/
            ssh -t $user@$host bash -c "'
                source ~/.bash_profile
                ./$0 $user@$host
                rm ./my_computers
                rm ./$0
                '"
        else
            ssh -t $user@$host bash -c "'
                echo "logged on to $host"
                '"
        fi
    fi
done

