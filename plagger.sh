#!/bin/bash -l

export PERL5LIB=$HOME/usr/lib/perl5

set +o noclobber

/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/no-eft.yaml &> /tmp/plagger_log1
/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/with-eft.yaml &> /tmp/plagger_log2
#/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/vansterpartiet.yaml
