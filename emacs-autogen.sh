#!/bin/bash

# Copyright © Stefan Kangas 2021-2022 <stefankangas@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -o nounset
set -o errexit

PN=${0##*/}                     # basename of script
PD=${0%/*}

die ()                 # write error to stderr and exit
{
    [ $# -gt 0 ] && echo "$PN: $*" >&2
    exit 1
}

eval `keychain -q --eval`
cd ~/wip/emacs-auto/$1-loaddefs/              || die "No such directory"
git reset -q --hard origin/$1                 || die "Reset error"
git pull -q --ff-only                         || die "Pull error"
nice -n19 ./admin/update_autogen -C -L -c     || die "Failed"
