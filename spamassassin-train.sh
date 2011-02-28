#!/bin/bash

sa-learn --no-sync --ham /home/skangas/Maildir/inbox-archive/cur
sa-learn --no-sync --spam /home/skangas/Maildir/spam.definite/cur
sa-learn --sync
#sa-update
