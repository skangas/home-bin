#!/usr/bin/perl

use 5.010_000;
use warnings;
use strict;

use File::Slurp qw(slurp);
use WWW::Tumblr;

our $VERSION = '0.01';

=head1 NAME

tumblrpost.pl - 

=cut

my ($emailfile, $urlfile, $userfile, $passfile) = @_;

$emailfile //= "$ENV{HOME}/bin/.tumblremail";
my $email = slurp($emailfile);

$urlfile //= "$ENV{HOME}/bin/.tumblrurl";
my $url = slurp($urlfile);

$userfile //= "$ENV{HOME}/bin/.tumblruser";
my $user = slurp($userfile);

$passfile //= "$ENV{HOME}/bin/.tumblrpass";
my $pass = slurp($passfile);

chomp $email; chomp $user;
chomp $pass;  chomp $url;

# read method
my $t = WWW::Tumblr->new(
    email    => $email,
#    user     => $user,
    password => $pass,
    url => $url,
);

#$t->url($url);

say join " ", $email, $user, $pass;

print $t->read();

$t->authenticate() or die $t->errstr;

$t->check_audio() or die "Unable to post audio";

=head1 AUTHOR

Stefan Kangas C<< <skangas at skangas.se> >>

=head1 BUGS

Please report any bugs to C<< <skangas at skangas.se> >>

=head1 COPYRIGHT

Copyright 2012 Stefan Kangas, all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as perl itself.

=cut

1; # End of tumblrpost.pl

__END__

