#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

my @data = (1, 2, 3, 4, 5, 6);

# my @res  = map { $_ * $_ } grep { $_ % 2 == 0 } @data;
# my @res  = map { $_ % 2 == 0 ? $_ * $_ : () } @data;

$, = ' ';
say @res;
