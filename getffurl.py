#!/usr/bin/env python

# Script to get the currently active Firefox URL 
# Copyright (c) 2017, Stefan Kangas
# Licensed under GPLv3

# Before you can use this:
#  pip install --user lz4

import glob
import itertools
import lz4
import json
import os
import sys

################################################################################
# Apparently Firefox now uses lz4 with a special magic number to compress the
# session files.  Ugh.  So now we need to do this crap:

def decompress(file_obj):
    if file_obj.read(8) != b"mozLz40\0":
        raise IOError("Invalid magic number")
    return lz4.block.decompress(file_obj.read())

# Not used, but included for documentation purposes:
# def compress(file_obj):
#     compressed = lz4.compress(file_obj.read())
#     return b"mozLz40\0" + compressed

################################################################################

locations = [
    "~/Library/Application Support/Firefox/Profiles/*/sessionstore-backups/recovery.jsonlz4",
    "~/.mozilla/firefox/lqdumxoy.Stefan/sessionstore-backups/recovery.js"
]
locations = [glob.glob(os.path.expanduser(loc)) for loc in locations]

f = None
filename = None
for fn in list(itertools.chain.from_iterable(locations)):
    print "%s" % (fn)
    if not fn:
        continue
    try:
        f = open(fn, 'r')
        filename = fn
    except IOError:
        pass

if not f:
    print "ERROR: Unable to open session store, tried:\n    %s" % ("\n    ".join(locations))
    sys.exit(1)

if filename.endswith(".jsonlz4"):
    jdata = json.loads(decompress(f))
else:
    # Support legacy
    jdata = json.loads(f.read())
f.close()

# Find the tab that was last accessed
latest = 0
urls = []
for win in jdata["windows"]:
    for tab in win["tabs"]:
        i = tab["index"] - 1
        if tab["lastAccessed"] > latest:
            latest = tab["lastAccessed"]
            url = tab.get("entries")[i].get("url")

# Don't add any newline
sys.stdout.write(url.strip())
