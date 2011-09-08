#!/bin/bash

SESSION=$1

[[ "$SESSION" != "" ]] || SESSION=default

screen -ls|grep $SESSION 2>&1> /dev/null

if [ $? -eq 0 ]; then
    screen -Dr $SESSION
else
    screen -c ~/.screen/$SESSION
fi
