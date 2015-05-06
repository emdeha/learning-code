#!/usr/bin/perl

use strict;
use warnings;
use v5.20;


use Person;


my $argC = $#ARGV + 1;
die ("Usage: person-use.pl <name> <age>") if $argC != 2;

my $person = Person->new(
    name => $ARGV[0],
    age => $ARGV[1]
);

say "ARGV[0]: $ARGV[0]\nARGV[1]: $ARGV[1]";
say $person->name;
say $person->age;
