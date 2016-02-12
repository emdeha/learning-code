#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;


sub compare_lengths {
  $a > $b;
}

my @unsorted = (5, 3, 2, 10);

# May confuse humans
{
my @sorted = sort compare_lengths @unsorted;

local $, = ' ';
say @sorted;
}

# OK
{
my $comparison = \&compare_lengths;
my @sorted = sort $comparison @unsorted;

local $, = ' ';
say @sorted;
}

# Does not work
# {
# my @sorted = sort \&compare_lengths @unsorted;
# 
# local $" = ' ';
# say @sorted;
# }
