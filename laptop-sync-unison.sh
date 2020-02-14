#!/bin/bash

source ~/bin/lib

[[ `uname` == "Darwin" ]] || exit 1

UNISON="unison -ui text -batch -silent"

if _allowed_network; then
    #echo ">>>>> elfeed"
    $UNISON -prefer newer /Users/skangas/.elfeed ssh://skangas@sk1917.duckdns.org/.elfeed

    #echo ">>>>> notmuch"
    $UNISON -prefer newer /Users/skangas/.notmuch-config ssh://skangas@sk1917.duckdns.org/.notmuch-config

    #echo ">>>>> msmtprc"
    $UNISON -prefer newer /Users/skangas/.msmtprc ssh://skangas@sk1917.duckdns.org/.msmtprc

    #echo ">>>>> Mail"
    $UNISON /Users/skangas/Mail ssh://skangas@sk1917.duckdns.org/Mail

else
    # We are probably on mobile data.  Synchronize *only* things that require
    # low bandwith -- that is, not the notmuch tags.
    $UNISON -ignore="Path .notmuch" /Users/skangas/Mail ssh://skangas@sk1917.duckdns.org/Mail
fi
