#!/bin/bash

sudo mount /mnt/backup/
mount | grep "on /mnt/backup type"

if [[ "$?" == 0 ]]; then
    sudo rsync -auvx -E -H --delete --ignore-errors \
    / /home /var /usr /home/skangas/windows /mnt/backup/slash/
else
    exit 1
fi

