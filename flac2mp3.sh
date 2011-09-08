#!/bin/bash

case $1 in
v0)
	LAMEQUALOPT="-V 0 --vbr-new";;
v2)
	LAMEQUALOPT="-V 2 --vbr-new";;
320)
	LAMEQUALOPT="-b 320";;
*)
	echo "Usage: `basename $0` [v0|v2|320]"
	exit 1;;
esac

# display cruft
find -type f -iname "*.!ut"

# remove cruft
find -type f \( -iname "*.m3u" -or -iname "*.m3u8" -or -iname "*.cue" -or -iname "*.sfv" \) -delete

# encode
find -type f -iname '*.flac' -print0 | while read -d $'\0' file

do
OUTF=`echo "$file" | sed s/\.flac$/.mp3/g`

ARTIST=`metaflac "$file" --show-tag=ARTIST | sed s/.*=//g`
TITLE=`metaflac "$file" --show-tag=TITLE | sed s/.*=//g`
ALBUM=`metaflac "$file" --show-tag=ALBUM | sed s/.*=//g`
GENRE=`metaflac "$file" --show-tag=GENRE | sed s/.*=//g`
TRACKNUMBER=`metaflac "$file" --show-tag=TRACKNUMBER | sed s/.*=//g`
DATE=`metaflac "$file" --show-tag=DATE | sed s/.*=//g`

flac -c -d "$file" | lame -m j -q 0 $LAMEQUALOPT - "$OUTF"
id3v2 -2 -t "$TITLE" -T "${TRACKNUMBER:-0}" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -g "${GENRE:-12}" "$OUTF"

echo "NEXT $file"

# delete file when done
rm -f "$file"

done
