#!/bin/bash

# Copyright © 2021-2022 Stefan Kangas <stefankangas@gmail.com>

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

eval `keychain -q --eval`
cd ~/wip/emacs-auto/emacs-automerge/
script_loc=$(mktemp -d)
trap 'rm -rf $script_loc 2> /dev/null' EXIT
cp admin/emacs-shell-lib "$script_loc"
cp admin/automerge "$script_loc"
chmod u+x "$script_loc/automerge"
nice -n 19 "$script_loc/automerge" -n1 -r -b -t -p -d || exit 1
