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
## This is supposed to be copied or symlinked into the directory
## /etc/NetworkManager/dispatcher.d
##

IF=$1
STATUS=$2
USER=skangas

wait_for_process() {
  PNAME=$1
  PID=`/usr/bin/pgrep $PNAME`
  while [ -z "$PID" ]; do
        sleep 3;
        PID=`/usr/bin/pgrep $PNAME`
  done
}

if [ "$IF" == "eth0" ] && [ "$STATUS" == "up" ]; then
    # NETMASK="10.0.0.0/8"
    # if [ -n "`/sbin/ip addr show $IF to $NETMASK`" ]; then
    #     ARGS=""
    #     exit $?
    # fi
fi

if [ "$IF" == "eth0" ]; then
    if [ "$STATUS" == "up" ]; then
        service openbsd-inetd start
    else
        service openbsd-inetd stop
    fi
fi


