#!/usr/bin/perl

use 5.012;
use warnings;
use strict;

my $str = "1a";

if ($str == 0 && $str ne "0") {
    warn "That doesn't look like a number";
}
