#!/bin/bash

IFS=$'\n'

for l in `cat my_computers`; do

    comp=${l%%#*}
    if [[ ${#comp} -gt 0 ]]; then

        user=`echo $comp | tr -s ' ' | cut -d ' ' -f 1`
        host=`echo $comp | tr -s ' ' | cut -d ' ' -f 2`

        echo "=============="
        echo "${user}@${host}"

        ssh -t $user@$host bash -c "'
            rm -f ~/.ssh/known_hosts
            '"
    fi
done

