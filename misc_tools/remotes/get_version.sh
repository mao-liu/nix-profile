#!/bin/bash

if [ `command -v sw_vers` ]; then
    sw_vers
else
    f=`find /etc -maxdepth 1 -type f -regex '.*\(version\|release\)'`
    echo $f
    cat $f
fi
