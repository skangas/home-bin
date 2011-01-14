#!/bin/bash -l

export PERL5LIB=/home/skangas/usr/lib/perl5

/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/no-eft.yaml &> /tmp/plagger_log1
/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/with-eft.yaml &> /tmp/plagger_log2
#/home/skangas/src/plagger/plagger --config=/home/skangas/src/plagger/config/vansterpartiet.yaml
