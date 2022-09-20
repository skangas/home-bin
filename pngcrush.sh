#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: `basename $0` foo.png [...]" >&2
  exit 1
fi
for file in "$@"; do
  # tmpfile=`mktemp .pngcrush.XXXXXXXX` || exit 1
  pngcrush -brute -fix "$file" || exit 1
  mv pngout.png "$file"
done
