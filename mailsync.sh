#!/bin/bash

# Copyright (C) 2021-2022 Stefan Kangas <stefankangas@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
