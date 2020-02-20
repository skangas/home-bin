#!/bin/bash

# This runs automatically from crontab on my laptop.
# See alse laptop-backup.sh

cd $HOME

REMOTE_HOST=ssh://skangas@sk1917.duckdns.org
VERBOSE="-silent"

source ~/bin/lib

[[ `uname` == "Darwin" ]] || exit 1

while getopts ":vf" opt; do
  case ${opt} in
    v )
        VERBOSE=""
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

# Always do this.
$UNISON -prefer newer /Users/skangas/.notmuch-config ${REMOTE_HOST}/.notmuch-config
$UNISON -prefer newer /Users/skangas/.msmtprc ${REMOTE_HOST}/.msmtprc

# Only do this on a high-speed network.
if _allowed_network || [[ $FORCE ]]; then
    $UNISON -prefer newer /Users/skangas/.elfeed ${REMOTE_HOST}/.elfeed

    #echo ">>>>> Mail"
    $UNISON -prefer newer /Users/skangas/Mail ${REMOTE_HOST}/Mail

else
    true # do nothing
    # We are probably on mobile data.  Synchronize *only* things that require
    # low bandwith -- that is, not the notmuch tags.

    # $UNISON -ignore="Path .notmuch" /Users/skangas/Mail ${REMOTE_HOST}/Mail
fi
