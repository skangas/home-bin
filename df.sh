#!/bin/bash

df -h | egrep -v "^(udev|tmpfs)"
