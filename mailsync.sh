#!/bin/bash

# lock -- see flock(1) for more details
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

# configuration
MAIL_ROOT=~/.mail/account.gmail/
GMI=$HOME/src/lieer/gmi
GMI_FLAGS="--quiet"
NOTMUCH_FLAGS="--quiet"

# sync mail
cd $MAIL_ROOT
$GMI manage_queue --quiet -r -C ~/.mail/account.gmail
$GMI sync $GMI_FLAGS
notmuch new $NOTMUCH_FLAGS

echo $(date "+%Y-%m-%d %H:%M") "*** DONE *** "
