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

# configuration
MAIL_ROOT="$HOME/.mail/account.gmail/"
GMI="$HOME/src/lieer/gmi"

# lock -- see flock(1) for more details
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

# Treat unset variables as an error.
set -o nounset

# Exit immediately on error.
set -o errexit

GREEN='\033[0;32m'
NC='\033[0m' # No color

die ()                 # write error to stderr and exit
{
    [ $# -gt 0 ] && echo "$PN: $@" >&2
    exit 1
}

print_log ()
{
    echo -e "$GREEN$(date "+%Y-%m-%d %H:%M:%S") $@$NC"
}

gmi_flags=""
notmuch_flags=""

while getopts "q" option ; do
    case $option in
        (q) gmi_flags="--quiet"
            notmuch_flags="--quiet"
            ;;

        (*) die "getopts error" ;;
    esac
done

print_log '*** START ***'

cd $MAIL_ROOT

# send emails
print_log "Sending emails ('gmi manage_queue')..."
torsocks $GMI manage_queue -r -C ~/.mail/account.gmail

# fetch emails
print_log "Fetching emails ('gmi sync')..."
torsocks $GMI sync $gmi_flags

# filter emails with notmuch
print_log "Filtering emails ('notmuch new')..."
notmuch new $notmuch_flags

print_log '*** DONE ***'
