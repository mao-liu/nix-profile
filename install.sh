#!/bin/bash

# print usage if invoked with -h or --help
if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    echo "$0 [osx|linux|profiles]"
    echo "creates symlinks in ${HOME}/bin or ${HOME}"
    exit 0
# are we loading bash and vim profiles?
elif [[ $1 == "profiles" ]]; then
    dir="profiles"          # directory containing profiles
    suffix="/.[a-z]*"       # link .[a-z]* files
    chk="-e"                # check the file exists before linking
    dest="${HOME}"          # place links into here
else
    common="common|gplot"   # directory with cross-platform scripts
    suffix="/*"             # link every file
    chk="-x"                # check the file is an executable
    dest="${HOME}/bin"      # place links into here
    if [[ $1 == "osx" ]]; then
        dir="@(${common}|osx)"      # directories to search
    elif [[ $1 == "linux" ]]; then
        dir="@(${common}|linux)"    # directories to search
    elif [[ $1 == "" ]]; then
        # if no OS specified, then only link cross-platform scripts
        dir="@(${common})"
    else
        echo "Invalid argument: $1."
        exit 0
    fi
fi

# get the absolute directory of this script
scriptdir=`pwd`"/${0#./}"
scriptdir=${scriptdir%/*}

# the search directories are compiled here
shopt -s extglob    # we need extended glob
search="${scriptdir}/${dir}${suffix}"

# get the directory we will link everything into
if [ ! -d $dest ]; then
    echo "mkdir $dest"
    mkdir -p $dest
fi

# set counters
new=0
success=0
fail=0

# make links
for s in $search; do

    # must pass a check
    # e.g. chk="-x" ensures only executables are linked
    if [ ! $chk $s ]; then
        continue
    fi

    name=${s##*/}             # short name of the script
    new_path=${dest}/${name}  # location of the link

    # only create link if it doesn't exist
    if [ ! -e ${new_path} ]; then
        echo $s
        ln -s $s $dest/
        new=$(( $new + 1 ))
    fi

    # check if it is the correct link
    if [ -L ${new_path} ] && [ `readlink ${new_path}` -ef $s ]; then
        success=$(( $success + 1 ))
    else
        # otherwise, there has been a conflict
        echo "conflict: ${s##*/}"
        fail=$(( $fail + 1 ))
    fi

done

echo "$new new links created."
echo "$success links verified."
echo "$fail conflicts."
