#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;


open my $fh, "<", "file-slurp.pl"
  or die "can't open file";

my $file = do { local $/; <$fh> };
say $file;

# Kill the kittens
eval "$file";
