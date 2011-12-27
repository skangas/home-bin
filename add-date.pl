#!/usr/bin/perl

use 5.010_000;
use warnings;
use strict;
use English;

=head1 NAME

add-date - add mtime to the beginning a file

=cut

use Data::Dumper;
use DateTime;
use File::stat;

my $file = $ARGV[0];
my $stat = stat($file);

my $fmt = 'yyyy-MM-dd hh:mm:ss';

my $mtime = DateTime->from_epoch(epoch => $stat->mtime)->format_cldr($fmt);

{
    local @ARGV = ($file);
    local $INPLACE_EDIT = '';
    while (<>) {
        if ($. == 1) {
            print "|-----------------------------|\n";
            print "| Ändrad: $mtime |\n";
            print "|-----------------------------|\n";
            print "\n";
        }
        print;
    }
}

=head1 AUTHOR

Stefan Kangas C<< <skangas at skangas.se> >>

=head1 COPYRIGHT

Copyright 2011 Stefan Kangas, all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as perl itself.

=cut
