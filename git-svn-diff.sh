#!/bin/bash

# git-svn-diff
# Generate an SVN-compatible diff against the tip of the tracking branch
TRACKING_BRANCH=`git config --get svn-remote.svn.fetch | sed -e 's/.*:refs\/remotes\///'`
REV=`git svn find-rev $(git rev-list --date-order --max-count=1 $TRACKING_BRANCH)`
git diff --no-prefix $(git rev-list --date-order --max-count=1 $TRACKING_BRANCH) $* |
sed -e "s/^+++ .*/& (working copy)/" -e "s/^--- .*/& (revision $REV)/" \
-e "s/^diff --git [^[:space:]]*/Index:/" \
-e "s/^index.*/===================================================================/"

