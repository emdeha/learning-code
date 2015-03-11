#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

MAIN:
{
    while (<>) {
        chomp;
        my @chars = split '', lc;
        say "@chars";
    }
}
