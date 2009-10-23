#!/bin/bash

APTITUDE="/usr/bin/aptitude"
SHELL="/bin/bash"
SUDO="/usr/bin/sudo"

echo "Will run 'aptitude update' and then run 'aptitude' if there were no problems"

$SUDO $APTITUDE update

status=$?

if [ $status -eq 0 ]; then
    echo "** Update:  OK"
    echo "** Running: $SUDO $APTITUDE"
    exec $SUDO $APTITUDE
else
    echo "** Update:  ERRORS"
    echo "** Running: $SHELL"
    exec $SHELL
fi
