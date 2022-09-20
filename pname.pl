#! /usr/bin/perl

# Copyright (C) 2004-2009 Lars Eggert <lars.eggert@gmx.net>
# All rights reserved.
#
# Redistribution and use in source and binary forms are permitted
# provided that the above copyright notice and this paragraph are
# duplicated in all such forms and that any documentation,
# advertising materials, and other materials related to such
# distribution and use acknowledge that the software was developed
# by Lars Eggert. The name of the author may not be used to endorse
# or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE.

# $Id: pname.pl,v 1.6 2009/09/29 11:42:18 eggert Exp $

use warnings;
use strict;
use lib qw(/usr/local/Library/Perl);

use Algorithm::ChooseSubsets;
use Text::Aspell;
use Time::HiRes qw(gettimeofday tv_interval);


my $title = lc join " ", @ARGV;
my @set = split / */, $title;
my $subsets = new Algorithm::ChooseSubsets \@set, scalar @ARGV, 1;
my %words = ();
my $done = 0;
my $maxlength = 0;
my $count = 0;
my $print_it = 0;
my $start = [gettimeofday];


# Show the found word as uppercase letters in the original string.
# (Does not take multiple variants into account!)
#
sub upcase ($$) {
	my ($string, $word) = @_;
	$string = lc $string;

	my $pos = 0;
	foreach my $letter (split / */, $word) {
		until (substr($string, $pos, 1) eq $letter) { $pos++; }
		substr($string, $pos, 1) = uc $letter;
        }

	return $string;
}

sub print_status () {
    print "\n";
    foreach my $word (sort keys %words) {
        my $spaces = " " x ($maxlength + 3 - length $word);
        print $word . $spaces . upcase($title, $word) . "\n";
    }
    print "search took " . tv_interval($start) ." seconds\n";
    $print_it = 0;
}


my $english = Text::Aspell->new;
#my $german = Text::Aspell->new;
die "cannot initialize speller" unless $english;# and $german;
$english->set_option("lang", "en_US");
#$german->set_option("lang", "de_DE");

die "must give title on command line" unless defined $ARGV[0];

$SIG{TERM} = $SIG{INT} = sub { $done = 1 }; # kill when we get a kill
$SIG{HUP} = sub { $print_it = 1 }; # print current state and continue
$| = 1;
while (my $abbrev = $subsets->next and not $done) {
	my $word = join "", @$abbrev;
	if ($english->check($word)) { # or $german->check($word)) {
		$count++ unless $words{$word};
		$words{$word}++;
		my $len = length $word;
		if ($len > $maxlength) {
			$maxlength = $len;
			print " $count found.\n" unless $count == 1;
			$count = 0;
			print "Finding words with $len characters...";
		}
	}
        # check if we need to print current state
        print_status if $print_it;
}
print_status;
