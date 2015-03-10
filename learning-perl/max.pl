#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use Data::Dumper;

my %hash;
@hash{1, 5, 12} = ('a', 'c', 'd');

say "Keys:\t".join "\t", sort { $a <=> $b } keys %hash;
