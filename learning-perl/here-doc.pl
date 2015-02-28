#!/usr/bin/perl

use 5.012;
use warnings;
use strict;

my @sauces = <<End_Lines =~ m/(\S.*\S)/g;
    normal tomato
    spicy tomato
    green chile
    pesto
    white wine
End_Lines

$" = "\n";
say "@sauces";
