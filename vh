#!/bin/bash
#########################################################################
#
# vh -- helper script that I use to maintain my home directory in version
# control using git
#
# Based on tools and ideas by Joey Hess and Martin F. Krafft
#
# Please refer to their home pages for more information:
# http://madduck.net/
# http://kitenet.net/~joey/
#
#########################################################################
#
# Copyright © 2009 Stefan Kangas <stefan@marxist.se>
#
#########################################################################
#
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
#
#########################################################################

#
## Configuration options

# This is the local base of your repositorys.
if [ -z "$VH_BASE_SUFFIX" ]; then
    VH_BASE_SUFFIX=".etc"
fi
VH_BASE="$HOME/$VH_BASE_SUFFIX"

# This is the remote base of your repositorys.
ORIGIN_BASE="gitosis@git.marxist.se:"

# This is an optional prefix to use for remote repositorys
if [ -z "$ORIGIN_PREFIX" ]; then
    ORIGIN_PREFIX="etc/"
fi
ORIGIN_BASE="$ORIGIN_BASE$ORIGIN_PREFIX"

#
## Shell options

# -e  Exit immediately if a command exits with a non-zero status.
set -e

#
## Sanity test
if [ ! -d "$VH_BASE" ]; then
    echo "Does not exist or is not a directory: $VH_BASE"
fi
# TODO: Make sure we have necessary tools and check paths for them using which

#
## Functions

function create_new_repos () {
    repos_name="$1"
    new_repos="$VH_BASE/$repos_name.git"
    mkdir -p $new_repos
    cd $new_repos
    git init --bare
    git config core.worktree ../../
    echo "(DD) Using origin $ORIGIN_BASE$repos_name"
    git remote add origin "$ORIGIN_BASE""$repos_name" # no .git needed
    git config core.bare false # this needs to be after remote add
    cd
    echo;echo "(II) Automatically spawning work environment."
    echo "(II) Please add files to the newly created repository; they will be automatically commited when exiting this shell."
    spawn_git_environment $repos_name

    # automatically commit the files
    cd $new_repos
    git commit -a -m"initial import"

    # push the new repository
    read -p "Do you want to 'git push' the repository (remote is $ORIGIN_BASE) (y/n)? "
    if [ $REPLY != "y" ]; then
        echo "Exiting..."
        exit 1
    fi
    git push origin master:refs/heads/master

    # add configuration file for mr
    mkdir -p ~/.mr
    cat <<_eof >> ~/.mrconfig
[$VH_BASE_SUFFIX/$repos_name.git]
checkout = git_fake_bare_checkout '$ORIGIN_BASE$repos_name.git' '$repos_name.git' '../../'

_eof

    cd
    exit 0
} # end create_new_repos

function spawn_git_environment () {
    if [ -z $1 ]; then
        echo "spawn_git_environment: must specify repos"
        return 1
    fi

    # set new
    export PS1="\n### NOW USING CUSTOM ENVIRONMENT: `basename ${0}`: ${1} ### \n\u@\h:\w\$ "
    export GIT_DIR="$VH_BASE/${1}.git"
    export GIT_WORK_TREE="$GIT_DIR"/"$(git config --get core.worktree)"
    
    # spawn shell
    stty sane
    $SHELL --norc -i
} # end spawn_git_environment

#
## Parse command line

if [ "$1" == "list" ]; then
    echo "Repositories: "
    for i in `ls -1 $VH_BASE`; do
        echo $i | cut -d. -f1
    done
    exit 0

elif [ "$1" == "env" ]; then
    name="$2"
    if [ -z "$name" ]; then
        echo "Must specify a repository"
        exit 1
    fi
    if [ ! -d "$VH_BASE/${name}.git" ]; then
        echo "No such repository: $name"
        exit 1
    fi
    echo "Spawning work environment for \"$name\""
    spawn_git_environment $name
    exit 0

elif [ "$1" == "new" ]; then
    name="$2"
    if [ -z "$name" ]; then
        echo "Must specify name for new repository."
        exit 1
    fi
    if [ -d "$VH_BASE/${1}.git" ]; then
        echo "Already exists: $name in \"$VH_BASE\""
        exit 1
    fi
    create_new_repos $name
    exit 0
fi

echo "Usage: `basename $0` new <new-repos>   create a new repository"
echo "Usage: `basename $0` env <repos>       start shell with work environment"
echo "Usage: `basename $0` list              list current repositories"
