#!/usr/bin/perl

use 5.010_000;
use warnings;
use strict;

=head1 NAME

imdb2org.pl - Convert imdb info to org-mode properties

=cut

our $VERSION = '0.01';

use IMDB::Film;

# Get the film ID
$ARGV[0] =~ m{^http://www\.imdb\.com/title/tt(\d+)/?};
my $id = $1;
$id //= $ARGV[0]; #fallback

my $film = new IMDB::Film(
    crit            => $id,
    user_agent      => 'Mozilla/5.0 (X11; Linux i686 on x86_64; rv:2.0.1) Gecko/20100101 Firefox/4.0.1',
    timeout         => 2,
    debug           => 0,
    cache           => 1,
    cache_root      => '/tmp/imdb_cache',
    cache_exp       => '1 d',
);

sub isay {
    my $prefix = shift;
    my $data .= join "", @_;

    if (length $data > 0) {
        say " " x 2 . "$prefix: $data";
    }
}

sub awards {
    my @awards = @{ shift() };
    return join ", ", map {
        "[[http://www.imdb.com/title/tt$id/awards][" .
        $_ . "]]";
    } @awards;
}

sub country {
    my @countries = @{ shift() };
    return join ", ", map {
        #"[[http://www.imdb.com/country/" .
            $_
                #. "][" . $_ ."]";
    } @countries;
}

sub genres {
    my @genres = @{ shift() };
    return join ", ", map {
        "[[http://www.imdb.com/genre/" . $_ . "][" . $_ . "]]";
    } @genres;
}

sub language {
    my @languages = @{ shift() };
    return join ", ", map {
        $_;
    } @languages;
}

sub persons {
    my @persons = @{ shift() };
    return join ", ", map {
        "[[http://www.imdb.com/name/nm" . $_->{id} . "/]" .
        "[" . $_->{name} . "]]";
    } @persons;
}

sub plot {
    my $plot = shift;
    $plot =~ s/\s*See full summary.+$//;
    return $plot;
}

sub rating {
    my($rating, $vnum, $avards) = $film->rating();
    return "$rating ($vnum votes)";
}


say "* " . $film->title() . " (" . $film->year() . ")";
say "  :PROPERTIES:";


isay "Genres", genres $film->genres();
isay "Plot", plot $film->full_plot();
isay "Director", persons $film->directors();
isay "Writer", persons $film->writers();
isay "Tagline", $film->tagline;
isay "Kind", $film->kind;
isay "Rating", rating $film->rating;
isay "Duration", $film->duration;
isay "Country", country $film->country;
isay "Language", language $film->language;
isay "Awards", awards $film->awards;


say "  :END:";

say "";
isay "[[IMDB][" . "]";
say "";

=head1 AUTHOR

Stefan Kangas C<< <skangas at skangas.se> >>

=head1 COPYRIGHT

Copyright 2011 Stefan Kangas, all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as perl itself.

=cut
