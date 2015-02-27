#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

my @data = (1, 2, 3, 4, 5, 10);

my @res;

#####
## Using map
#####
# @res = map ($_ * $_, @data);

#####
## Using foreach
#####
for (@data) {
    push @res, $_ * $_
}

say "@res";
