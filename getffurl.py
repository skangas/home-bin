#!/usr/bin/env python

import json
import sys

f = open("/home/skangas/.mozilla/firefox/lqdumxoy.Stefan/sessionstore-backups/recovery.js", "r")
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
