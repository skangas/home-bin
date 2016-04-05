#!/bin/bash

wallpapers="$HOME/.backgrounds/`hostname`/"
FONT="$HOME/.fonts/artwiz-aleczapka-se-1.3/cure.se.pcf"

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
        version=`uname -a`
        fil=`mktemp`
        fil2=`mktemp`
        calout=`cal`
        cp ${alist[$rand]} $fil
        i=100
        cal -ym | while read line; do
            convert -font $FONT -pointsize 100 -fill blue -draw "text 100,$i \"$line\"" $fil $fil
            i=`expr $i + 28`
            echo $line
        done
        display -window root $fil
        rm $fil
        # display -window root ${alist[$rand]}
    elif type feh > /dev/null; then
        feh --bg-scale ${alist[$rand]}
    else
        echo `basename $0`: no suitable software found
    fi
fi

