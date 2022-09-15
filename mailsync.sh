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
echo "Sending emails ('gmi manage_queue')..."
$GMI manage_queue --quiet -r -C ~/.mail/account.gmail
echo "Fetching emails ('gmi sync')..."
$GMI sync $GMI_FLAGS
echo "Filtering emails ('notmuch new')..."
notmuch new $NOTMUCH_FLAGS

echo $(date "+%Y-%m-%d %H:%M") "*** DONE *** "
