#!/bin/bash

BHOST="huey.skangas.se"

function do_backup {
    rsync -aux -E -H --delete --progress --quiet \
        $BHOST:/home/skangas/$1 $2
}

# Critical stuff
do_backup   .crypt      $HOME
do_backup   cbt         $HOME

# Not very critical stuff
do_backup   books       $HOME

# do_backup   .gnupg      $HOME
# do_backup   Mail        $HOME
# do_backup   Maildir     $HOME
# do_backup   News        $HOME
# do_backup   code        $HOME
# do_backup   dokument    $HOME
# do_backup   org        $HOME
# do_backup   wip/        $HOME/wip/lenin
