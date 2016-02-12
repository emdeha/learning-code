#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;

use Data::Dumper;


my %extensions = (
  '000' => 'Damian',
  '002' => 'Wesley',
  '012' => 'LaMarcus',
  '042' => 'Robin',
  '088' => 'Nic',
);

# Sorts %extensions by values
#
# Create an anon list from each key-val pair
my @pairs = map { [ $_, $extensions{$_} ] } keys %extensions;
# Sort by the val elem of the anon list
my @sorted = sort { $a->[1] cmp $b->[1] } @pairs;
# Convert it to string
my @formatted = map { "$_->[0] -> $_->[1]" } @sorted;

say Dumper(@formatted);

my @one_line = map { "$_->[0] -> $_->[1]" }
               sort { $a->[1] cmp $b->[1] }
               map { [ $_, $extensions{$_} ] } 
               keys %extensions;

say Dumper(@one_line);
