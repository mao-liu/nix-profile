#!/bin/bash

IFS=$'\n'

echo "" > $0.log

for l in `cat my_computers`; do

    comp=${l%%#*}
    if [[ ${#comp} -gt 0 ]]; then

        user=`echo $comp | tr -s ' ' | cut -d ' ' -f 1`
        host=`echo $comp | tr -s ' ' | cut -d ' ' -f 2`

        echo "=============="
        echo "${user}@${host}"

        ssh -t $user@$host bash -c "'
            cat .ssh/id_rsa.pub
            '"  | tee -a $0.log
    fi
done

grep "^ssh-rsa" $0.log > authorized_keys

