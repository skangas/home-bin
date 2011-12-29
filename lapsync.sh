#!/bin/bash

BHOST="huey.skangas.se"
BDIR="$HOME/huey-backup/"

function do_backup {
    rsync -aux -E -H --delete --progress \
        $BHOST:/home/skangas/$1 $2
}

# Critical stuff
do_backup   .crypt      $HOME
do_backup   cbt         $BDIR
do_backup   News        $BDIR

do_backup   code        $BDIR
do_backup   wip         $BDIR

do_backup   dokument    $BDIR
do_backup   .repos      $BDIR

# Not very critical stuff
do_backup   books       $BDIR

# do_backup   .gnupg      $HOME



