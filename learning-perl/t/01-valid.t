#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use Test::More tests => 5;
use Test::Command;

# Raw
stdout_is_eq('perl dragon.pl 1', "1\n");
stdout_is_eq('perl dragon.pl 4', "110110011100100\n");

# Turns
stdout_is_eq('perl dragon.pl -m turns 1', "1\n");
stdout_is_eq('perl dragon.pl -m turns 4', "110110011100100\n");

# Coords
stdout_is_eq('perl dragon.pl -m coords 2', "(0, 0) (0, 1) (1, 1) (1, 0) (2, 0)\n");
