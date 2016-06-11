#!/bin/sh

# by Michael Evans, slight modifications by Stefan Kangas
# http://www.mail-archive.com/linux-list@lists2.linuxjournal.com/msg00021.html

# Use bash for $RANDOM; however this now works in dash (using od and awk in addition to echo and dd)
### sdXn, raid, and lvm all have different sys-fs schemes, Either expand to force the user to specify.
if [[ "${1}" == "" ]]; then
    echo "usage: $0 <filename to fill with random data>"
    exit 1
fi

RND=/dev/urandom
BLOCK_SIZE=32k
DEV=${1}
#SIZE=${2}
POS=0
BLOCK_C=0

true
while [ "$?" = "0" ]; do
    BLOCK_C=$(( $( od -N1 -tu1 $RND | awk '$2{print $2}' ) + 1 ))
    BLOCK_V=$( od -N1 -tu1 $RND | awk '$2{print $2}' )
    if [ "${#BLOCK_V}" = 0 ]; then
        dd if=/dev/zero of=$DEV bs=$BLOCK_SIZE count=$BLOCK_C seek=$POS > /dev/null 2>&1
    else
        tr '\0' \\$BLOCK_V < /dev/zero | dd of=$DEV bs=$BLOCK_SIZE count=$BLOCK_C seek=$POS > /dev/null 2>&1
    fi
    POS=$(($POS + $BLOCK_C))
done
echo "Filled $DEV with $POS blocks of data."
