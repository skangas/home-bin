#!/bin/bash

# display cruft
find -type f -iname "*.!ut"

# remove cruft
find -type f \( -iname "*.m3u" -or -iname "*.m3u8" -or -iname "*.cue" -or -iname "*.sfv" \) -delete

# encode
find -type f -iname "*.flac" -exec oggenc -q8 {} \; -delete

# vorbisgain
type vorbisgain

if [ $? == 0 ]; then
    find -mindepth 1 -type d -exec vorbisgain -a -r -s -f "{}" \;
fi


