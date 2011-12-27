#!/bin/bash

BACKUP_DIRECTORY=/mnt/backup
HOST=`hostname`

# mount as needed
if [ `mount | grep "on /mnt/backup type" > /dev/null` ]; then
    # FIXME
    mount /mnt/backup/
fi

# do the backup only when mount succeded
if [ `mount | grep "on /mnt/backup type" > /dev/null` ]; then
    exit 1
fi

nice -n 19 ionice -c 3 \
    rsync \
    -auvx -E -H --delete-before --delete-excluded --ignore-errors --verbose --progress \
    --exclude=/dev --exclude=/proc --exclude=/sys --exclude=/var/cache/apt/archives --exclude=/var/lib/apt/lists/ \
    --exclude=/home/skangas/.wine \
    / /home /usr /var $BACKUP_DIRECTORY/$HOST



