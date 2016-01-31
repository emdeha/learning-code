#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Devel::StackTrace;

use v5.012;


sub whocallme {
    say Devel::StackTrace->new->as_string;

    wantarray
        ? (qw/list ctx/)
        : "scalar ctx";
}

say join ' ', whocallme;
say scalar(whocallme);
say whocallme;
