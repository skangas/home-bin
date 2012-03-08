#!/bin/bash

BACKUP_DIRECTORY=/mnt/backup
HOST=`hostname`

# mount as needed
if [ `mount | grep "on /mnt/backup type" > /dev/null` ]; then
    /home/skangas/bin/mount-backup.sh
fi

# do the backup only when mount succeded
if [ `mount | grep "on /mnt/backup type" > /dev/null` ]; then
    exit 1
fi

/usr/bin/rsnapshot $@

