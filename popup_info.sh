#!/bin/bash

XPOS=0
LINES=50
WIDTH=363

if [[ $1 == "-cal" ]]; then
    OUT=$(ncal -bMy)
    LINES=35
    WIDTH=550
else
    if [[ $1 == "-m" ]]; then
        XPOS=2197
        HEADER="%MEM"
        ARG="%mem"
    elif [[ $1 == "-c" ]]; then
        XPOS=2129
        HEADER="%CPU"
        ARG="%cpu"
    fi
    LINES=50
    WIDTH=363
    OUT=$(
        echo "$HEADER  PID   CMD"
        ps -eo $ARG,pid,cmd|grep -v $HEADER|sort -rn|head -$LINES|sed 's/^ *//g'|awk '{printf "%-5s %-6s %s\n", $1, $2, $3}'
)
fi

# Show memory information

echo -e "$OUT" | dzen2 -p -x "$XPOS" -y "16" -w $WIDTH -l $LINES -sa 'l' -ta 'l' -fn 'xft:lucidatypewriter:size=11' \
          -title-name 'popup_sysinfo' -e 'onstart=uncollapse;button0=exit;button1=exit;button3=exit'\
          -ta l -fg '#4586bb' -bg '#111111' -p 3
