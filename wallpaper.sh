#!/bin/bash

# Copyright © Stefan Kangas 2009-2019 <stefankangas@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
    img=${alist[$rand]}
    if type display > /dev/null; then
        # Resize image to fit desktop
        x=`xwininfo -root|grep "Width"|sed 's/[^0-9]//g'`
        y=`xwininfo -root|grep "Height"|sed 's/[^0-9]//g'`
        fil=`mktemp`
        cp $img $fil
        convert -resize ${x}x${y} $fil $fil
    
        # version=`uname -a`
        # calout=`cal`
        # cp ${alist[$rand]} $fil
        # i=100
        # cal -ym | while read line; do
        #     convert -font $FONT -pointsize 10 -fill blue -draw "text 100,$i \"$line\"" $fil $fil
        #     i=`expr $i + 28`
        #     echo $line
        # done
        # display -window root $fil
        # rm $fil
        display -window root $fil
        rm $fil
    elif type feh > /dev/null; then
        feh --bg-scale $img
    else
        echo `basename $0`: no suitable software found
    fi
fi
