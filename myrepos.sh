#!/bin/bash

cd $HOME
eval `keychain --eval`
mr -q commit -m"automatic update @ `hostname`" 1> /dev/null 2>&1
mr -q up 1> /dev/null 2>&1
mr -q push 1> /dev/null 2>&1
