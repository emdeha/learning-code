#!usr/bin/perl

use warnings;
use strict;

my %trans = (
    "EN" => "Hello!",
    "BG" => "Здрасти!",
    "CN" => "Ni Hao!"
);

open (IN, "< trans.json") 
    or die "can't open input";
my @cnts = <IN>;

open (FILE, "> trans_new.json") 
    or die "can't open output";

print FILE "{\n";

my $idx = 1;
for (keys %trans) {
    $cnts[$idx] =~ s/"": ""/"$_": "$trans{$_}"/g;
    print FILE $cnts[$idx];
    ++$idx;
}

print FILE "}";

close FILE;
close IN;
