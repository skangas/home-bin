#!/usr/bin/perl

use 5.010_000;
use warnings;
use strict;

=head1 NAME

mplayer-wrapper.pl - Wrap mplayer to find start/end of movies

=cut

our $VERSION = '0.01';

use Data::Dumper;
use IPC::Run qw( start pump finish );
use Term::ReadKey;

my @command = qw/mplayer -nosound/;
push @command, $ARGV[0];

my ($in, $out, $err);
my $h = start \@command, \$in, \$out, \$err;

sub read_frame {
    my $done = 0;
    my $frame;
    while (not $done) {
        $h->pump_nb;

        if ($out =~ m!^[^:]+:.+?(\d+)/\s*\d+!mgc) {
            $frame = $1;
            say "Found frame $frame.";
        }

        # Enable reading one character at a time
        ReadMode('cbreak');
        if (my $key //= ReadKey(-1)) {
            $done = 1 if defined $frame;
        }
        # Disable reading one character at a time
        ReadMode('normal');
    }
    return $frame;
}

say "Instructions:";
say "Find the correct frame in mplayer and pause the movie on that exact frame.\n";
say "Find start frame:";
say " (Press any key in this window to select this frame.)";
my $start = read_frame();
say "Find end frame:";
say " (Press any key in this window to select this frame.)";
my $end = read_frame();

say "";
say "Found start $start and end $end.";

#$h->finish();
$h->kill_kill();

=head1 COPYRIGHT

Copyright 2010 Stefan Kangas.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as perl itself.

=cut

1; # End of mplayer-wrapper.pl

__END__
