#!/bin/bash

sudo rsync -auvx -E -H --delete --ignore-errors / /home /var /usr /home/skangas/windows /mnt/backup/slash/

