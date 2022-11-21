#!/bin/bash

## Author: Stefan Kangas <stefankangas@gmail.com>

## This file is NOT part of GNU Emacs.

## GNU Emacs is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## GNU Emacs is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

### Commentary:

## Update some externally maintained files from upstream.
##
## Inspired by the automerge script by Glenn Morris <rgm@gnu.org>.

eval `keychain -q --eval`

EMACS_DIR="$HOME/wip/emacs-auto/emacs-update-files"
GIT_BRANCH="origin/master"

# git branch -a |grep remotes/origin/emacs-|tail -n1|sed 's/.*emacs-\([0-9]\+\)/emacs-\1/g'

die ()
{
    [ $# -gt 0 ] && echo "$PN: $*" >&2
    exit 1
}

PN=${0##*/}                     # basename of script

[ "$PD" = "$0" ] && PD=.        # if PATH includes PWD


show=
push=
quiet=
reset=

while getopts "rspq" option ; do
    case $option in
        (s) show=1 ;;

        (r) reset=1 ;;

        (p) push=1 ;;

        (q) quiet=1 ;;

        (\?) die "Bad option -$OPTARG" ;;

        (:) die "Option -$OPTARG requires an argument" ;;

        (*) die "getopts error" ;;
    esac
done
shift $(( --OPTIND ))
OPTIND=1


cd $EMACS_DIR || die "Could not change directory to $EMACS_DIR"

[ -d admin ] || die "Could not locate admin directory"

[ -e .git ] || die "No .git"

[ "$quiet" ] && exec 1> /dev/null


[ "$reset" ] && {
    echo "Resetting..."
    git reset -q --hard "$GIT_BRANCH" || die "reset error"

    echo "Pulling..."
    git pull -q --ff-only || die "pull error"
}


get_tempfile ()
{
    if [ -x "$(command -v mktemp)" ]; then
        echo "$(mktemp "/tmp/$PN.XXXXXXXXXX")"
    else
        echo "/tmp/$PN.$$"
    fi
}

## Check the number of lines changed to avoid checking in a bogus file.

git_check_lines_changed ()
{
    local max_lines ins del tot
    max_lines=$1
    ins=$(git diff --stat | grep insertion | \
          sed 's/ *[0-9]\+ files\? changed, \([0-9]\+\) insertions\?(+), [0-9]\+ deletions\?(-).*/\1/')
    del=$(git diff --stat | grep insertion | \
              sed 's/ *[0-9]\+ files\? changed, [0-9]\+ insertions\?(+), \([0-9]\+\) deletions\?(-).*/\1/')
    let tot=ins+del
    if [[ "x$tot" = "x" || "x$ins" = "x" ]]; then
        die "Unable to parse number of changed lines: tot=$tot ins=$ins del=$del"
    fi
    if (($tot > $max_lines)); then
        die "Too many lines changed: ${tot} (max: ${max_lines})"
    fi
}

fetch_file ()
{
    local url file max_lines file_date
    url="$1"
    file="$2"
    max_lines="$3"

    tempfile="$(get_tempfile)"
    curl --fail --verbose "$url" > "$EMACS_DIR/$file" 2>"$tempfile" \
        || die "Unable to fetch: $url"

    # Return unless we have something to do.
    if [[ "x$(git diff)" == "x" ]]; then
        return
    fi

    git_check_lines_changed "$max_lines"
    git add "$file" || die "Unable to add: $file"

    date=$(grep -E '^< last-modified' "$tempfile" | sed 's/^< last-modified: //') \
        || die "Unable to parse date"
    rm -f "$tempfile"

    file_date=
    if [[ ! "x$date" = "x" ]]; then
        file_date="dated "$(date -d "$date" -u "+%Y-%m-%d %H:%M:%S %Z")"."
    fi

    git commit -m "Update $(basename $file) from upstream

* ${file}: Update from
${url}
${file_date}" \
        || die "Unable to commit: $file"
}

trap 'rm -f $tempfile 2> /dev/null' EXIT

echo "Fetching files"

PUBLIC_SUFFIX_URL="https://publicsuffix.org/list/public_suffix_list.dat"
PUBLIC_SUFFIX_FILE="etc/publicsuffix.txt"
fetch_file "$PUBLIC_SUFFIX_URL" "$PUBLIC_SUFFIX_FILE" 500

SKK_JISYO_URL="https://raw.githubusercontent.com/skk-dev/dict/master/SKK-JISYO.L"
SKK_JISYO_FILE="leim/SKK-DIC/SKK-JISYO.L"
fetch_file "$SKK_JISYO_URL" "$SKK_JISYO_FILE" 100


[ "$show" ] && {
    git --no-pager show
}


[ "$push" ] || exit 0

echo "Pushing..."
git push

exit 0
