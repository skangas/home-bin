#!/bin/bash

MAILDIR="$HOME/Maildir"

if [ ! -d $MAILDIR ]; then
    exit
fi

FOUND_MAIL=`find $HOME/Maildir -type f -path 'Maildir/*new/*'|wc -l`

if [ $FOUND_MAIL -gt 0 ]; then
    echo "^fg(\#F00) $FOUND_MAIL NEW MAIL"
fi
