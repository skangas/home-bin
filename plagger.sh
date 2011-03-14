#!/bin/sh

PERL5LIB=$HOME/usr/lib/perl5
export PERL5LIB

LOGFILE=~/.plagger_log
rm -f $LOGFILE

/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/no-eft.yaml   1>>$LOGFILE 2>&1
/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/with-eft.yaml 1>>$LOGFILE 2>&1

#/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/vansterpartiet.yaml

chmod 0600 $LOGFILE

