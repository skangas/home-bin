#!/bin/bash

# This runs automatically from crontab on my laptop.
# See alse laptop-backup.sh

source ~/bin/lib

[[ `uname` == "Darwin" ]] || exit 1

while getopts ":vf" opt; do
  case ${opt} in
    v )
        VERBOSE="-silent"
        ;;
    f )
        FORCE=1
        ;;
    \? )
        echo "Usage: $0 [-f] [-v]"
        ;;
  esac
done

UNISON="unison -ui text -batch $VERBOSE"

if _allowed_network || [[ $FORCE ]]; then
    #echo ">>>>> elfeed"
    $UNISON -prefer newer /Users/skangas/.elfeed ssh://skangas@sk1917.duckdns.org/.elfeed

    #echo ">>>>> notmuch"
    $UNISON -prefer newer /Users/skangas/.notmuch-config ssh://skangas@sk1917.duckdns.org/.notmuch-config

    #echo ">>>>> msmtprc"
    $UNISON -prefer newer /Users/skangas/.msmtprc ssh://skangas@sk1917.duckdns.org/.msmtprc

    #echo ">>>>> Mail"
    $UNISON /Users/skangas/Mail ssh://skangas@sk1917.duckdns.org/Mail

else
    true # do nothing
    # We are probably on mobile data.  Synchronize *only* things that require
    # low bandwith -- that is, not the notmuch tags.

    # $UNISON -ignore="Path .notmuch" /Users/skangas/Mail ssh://skangas@sk1917.duckdns.org/Mail
fi
