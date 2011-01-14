#!/usr/bin/perl

use 5.010_000;
use warnings;
use strict;

=head1 NAME

webpass.pl - generate SHA-1 passwords using file as salt

=cut

our $VERSION = '0.01';

use Data::Dumper;
use Digest::SHA1  qw(sha1 sha1_hex sha1_base64);
use File::Slurp qw(slurp);

my $site = $ARGV[0];
my $passfile = $ARGV[1];

$site //= "example.com";
$passfile //= "$ENV{HOME}/bin/.webpass";

my $pass = slurp($passfile);

my $generated = substr sha1_base64($pass . ":" . $site), 0, 8;
$generated .= "1a";

Clipboard->copy($generated);

BEGIN {
    # This code is from Cliboard v0.13 by Ryan King (found on CPAN)
    package Clipboard;
    sub copy {
        my $self = shift;
        my ($input) = @_;
        $self->copy_to_selection($self->favorite_selection, $input);
    }
    sub copy_to_selection {
        my $self = shift;
        my ($selection, $input) = @_;
        my $cmd = '|xclip -i -selection '. $selection;
        my $r = open my $exe, $cmd or die "Couldn't run `$cmd`: $!\n";
        print $exe $input;
        close $exe or die "Error closing `$cmd`: $!";
    }
    sub paste {
        my $self = shift;
        for ($self->all_selections) {
            my $data = $self->paste_from_selection($_); 
            return $data if length $data;
        }
        undef
    }
    sub paste_from_selection {
        my $self = shift;
        my ($selection) = @_;
        my $cmd = "xclip -o -selection $selection|";
        open my $exe, $cmd or die "Couldn't run `$cmd`: $!\n";
        my $result = join '', <$exe>;
        close $exe or die "Error closing `$cmd`: $!";
        return $result;
    }
    # This ordering isn't officially verified, but so far seems to work the best:
    sub all_selections { qw(primary buffer clipboard secondary) }
    sub favorite_selection { my $self = shift; ($self->all_selections)[0] }
    {
        open my $just_checking, 'xclip -o|' or warn <<'EPIGRAPH';

Can't find the 'xclip' script.  Clipboard.pm's X support depends on it.

Here's the project homepage: http://sourceforge.net/projects/xclip/

EPIGRAPH
    }
}

=head1 SEE ALSO

http://www.angel.net/~nic/passwd.sha1.1a.html

=head1 AUTHOR

Stefan Kangas C<< <skangas at skangas.se> >>

=head1 COPYRIGHT

Copyright 2010 Stefan Kangas, all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as perl itself.

=cut
