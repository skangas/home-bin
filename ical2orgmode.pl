#!/usr/bin/perl

package ical2orgmode;

use warnings;
use strict;
use 5.010;

=head1 NAME

ical2orgmode.pl - Convert iCalendar to org-mode format

=cut

our $VERSION = '0.01';

use Data::Dumper;

use Data::ICal;
use DateTime::Format::ICal;

my $cal = Data::ICal->new( filename => $ARGV[0] );

say "* Schema" . (" " x 60) . ":school:";

MAIN:
for my $entry (@{$cal->entries}) {
    my %prop = get_properties($entry, qw/summary location dtend dtstart/);
    for my $key (keys %prop) {
        defined $prop{$key} || next MAIN;
    }

    ### SUMMARY
    my $summary = $prop{'summary'};
    # $summary =~ s/--\n//;

    $summary =~ s/
                 ( TKITE-2
                 | TKDAT-2
                 | MPSEN-1
                 )
                 //x;
    $summary =~ s/TKITE-2//;    
    $summary =~ s/^(.*)(?:Föreläsning|Förel)/Föreläsning: $1/sx;
    $summary =~ s/^(.*)(?:Övning|Övn)/Övning: $1/sx;
    $summary =~ s/^(.*)(?:Handledning|Handleding)/Handledning: $1/sx;
    $summary =~ s/^(.*)(?:Laboration|Lab)/Laboration: $1/sx;

    # Limit to one space
    $summary =~ s/\s+/ /g;
    # Remove whitespace at beginning/end of line
    $summary =~ s/( ^\s+ | \s+$ )//gix;

    $summary .= ' [' . $prop{'location'} . ']';

    ### DATE
    my $dt;
    $dt = DateTime::Format::ICal->parse_datetime($prop{'dtstart'});
    my $date = $dt->year . "-" . sprintf("%02d", $dt->month) . "-" . sprintf("%02d", $dt->day) . " "
             . sprintf("%02d", $dt->hour) . ":" . sprintf("%02d", $dt->minute);
    $dt = DateTime::Format::ICal->parse_datetime($prop{'dtend'});
    $date .= "-" . sprintf("%02d", $dt->hour) . ":" . sprintf("%02d", $dt->minute);
    
    say "*** $summary <$date>";
    # say "";
    # say "   :PROPERTIES:";
    # say "   :Course code: $location:";
    # say "   :END:\n";        
}

sub get_properties {
    my ($entry, @properties) = @_;
    my %props;
    for my $prop (@properties) {
        $props{$prop} = defined $entry->property($prop) ?
            $entry->property($prop)->[0]->value : undef;
    }
    return %props;
}


=head1 CAVEAT

This code will silently discard any data that looks unfamiliar.

=head1 COPYRIGHT

Copyright (c) 2010,2011 Stefan Kangas C<< <skangas at skangas.se> >>, all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as perl itself.

=cut
