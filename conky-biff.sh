#!/bin/bash

NEW_MAIL_TOTAL=0

find_new_mail() {
    FOUND_MAIL=`find $MAILDIR -type f -path '$MAILDIR/*new/*'|wc -l`    
}


MAILDIR="$HOME/Maildir"

if [ ! -d $MAILDIR ]; then
    exit
fi



if [ $FOUND_MAIL -gt 0 ]; then
    echo "^fg(\#F00) $FOUND_MAIL NEW MAIL ^fg(\#666)|"
fi
