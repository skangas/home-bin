#!/bin/bash

missing() {
    our_bin=$1
    echo $our_bin "is missing"
    exit 1
}

type flac &>/dev/null || missing flac

enc_flac8() {
    file=$1
    OUTF="$1.tmp"
    echo "File: \"$1\" -> \"$OUTF\""
    flac --verify "$1" --compression-level-8 --exhaustive-model-search --qlp-coeff-precision-search --force -o "$OUTF"
    echo "mv \"$OUTF\" \"$1\""
    mv "$OUTF" "$1"
}

enc_flac8 "$1"

# # display cruft
# find -type f -iname "*.!ut"

# # remove cruft
# find -type f \( -iname "*.m3u" -or -iname "*.m3u8" -or -iname "*.cue" -or -iname "*.sfv" \) -delete

# # encode
# find -type f -iname '*.flac' -print0 | while read -d $'\0' file do enc_mp3 $file; done
