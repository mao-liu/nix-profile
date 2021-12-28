#!/bin/bash

IFS=$'\n'

for l in `cat my_computers`; do

    comp=${l%%#*}
    if [[ ${#comp} -gt 0 ]]; then

        user=`echo $comp | tr -s ' ' | cut -d ' ' -f 1`
        host=`echo $comp | tr -s ' ' | cut -d ' ' -f 2`

        echo "=============="
        echo "${user}@${host}"

        cmd='ps -U `whoami` | grep ssh-agent | grep -v grep | awk "{print \$1}" | xargs kill
            rm ~/.ssh/environment
            source ~/.bash_profile'

        ssh -t $user@$host bash -c "$cmd"
    fi
done
