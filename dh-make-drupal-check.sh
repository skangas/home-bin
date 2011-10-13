#!/bin/bash

# Copyright 2011 Stefan Kangas.

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
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

##
## This script checks if Drupal modules installed using dh-make-drupal are up to
## date on a Debian GNU/Linux system.
##
## This should probably be implemented in dh-make-drupal itself but I just
## wanted to get the job done real quick.
##

modules="`dpkg -l|egrep 'drupal6-(mod|thm|trans)-'|cut -d' ' -f3`"

for mod in $modules; do
    auto_gen="`dpkg -s $mod|grep 'This is an auto-generated description made by dh-make-drupal.'`"
    if [ -z "$auto_gen" ]; then
        continue
    fi

    mod_name="`echo $mod | sed 's/drupal6-[^-]\+-//' | sed 's/-/_/g'`"

    version="`dh-make-drupal -r $mod_name|grep 'Release'|cut -d' ' -f2`"

    installed="`dpkg -l $mod|grep $mod|sed 's/ii\s\+\S\+\s\+\(\S\+\).*/\1/'|cut -d'-' -f1`"

    if [ -z "$version" ]; then
        echo "WARN: Unable to find a version for $mod"
        continue
    fi

    if [ "$version" != "$installed" ]; then
        echo "$mod needs upgrading. Version $version available but only $installed installed."

        dh_out=$(dh-make-drupal $mod_name 2>&1)
        package=$(echo "$dh_out" | grep 'dpkg-deb: building package' | sed 's/^dpkg-deb: building package `\S\+'\'' in `..\/\(\S\+\)'\''\.$/\1/')

        if [ -n "$package" ]; then
            echo "Successfully built $package."
        else
            echo "Unable to build package. dh-make-drupal gave the following error:"
            echo "$dh_out"
        fi
    else
        echo "$mod is uptodate."
    fi

done

