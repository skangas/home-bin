#!/bin/bash

WALLPAPERS="$HOME/.backgrounds"
ALIST=( `ls -w1 $HOME/.backgrounds` )
RANGE=${#ALIST[@]}
let "number = $RANDOM"
let LASTNUM="`cat $WALLPAPERS/.last` + $number"
let "number = $LASTNUM % $RANGE"
rm $WALLPAPERS/.last
echo $number > $WALLPAPERS/.last

feh --bg-scale $WALLPAPERS/${ALIST[$number]}
