#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use v5.012;


my @ary = qw/1 2 3 5 112 54 23 4 5/;

@ary[map{($_*2, $_*2+1)} 0..(@ary/2-1)] = @ary[map{($_*2+1, $_*2)} 0..(@ary/2-1)];

print join ",", @ary;
