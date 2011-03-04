#!/bin/bash

WALLPAPERS="$HOME/.backgrounds"

if [ -d $WALLPAPERS ]; then
    ALIST=( `ls -w1 $HOME/.backgrounds` )
    RANGE=${#ALIST[@]}
    let "number = $RANDOM"
    let LASTNUM="`cat $WALLPAPERS/.last` + $number"
    let "number = $LASTNUM % $RANGE"
    rm $WALLPAPERS/.last
    echo $number > $WALLPAPERS/.last

    if type display > /dev/null; then
        display -window root $WALLPAPERS/${ALIST[$number]}
    elif type feh > /dev/null; then
        feh --bg-scale $WALLPAPERS/${ALIST[$number]}
    else
        echo `basename $0`: no suitable software found
    fi
fi
