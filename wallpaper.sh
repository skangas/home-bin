#!/bin/bash

wallpapers="$HOME/.backgrounds/`hostname`/"

if [ -d $wallpapers ]; then
    last="$wallpapers/.last"
    alist=( `find $wallpapers -type f -not -name ".last"` )
    range=${#alist[@]}
    if [ -f $last ]; then
        lastnum="`cat $last`"
    else
        lastnum=-1
    fi
    while [ $((rand=$RANDOM%$range)) == $lastnum  ]; do
        :;
    done
    rm -f $last
    echo $rand > $last
    if type display > /dev/null; then
        display -window root ${alist[$rand]}
    elif type feh > /dev/null; then
        feh --bg-scale ${alist[$rand]}
    else
        echo `basename $0`: no suitable software found
    fi
fi

