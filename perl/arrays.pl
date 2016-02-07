#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;


my @bookshelf = ('Romeo', 'Craigslist', 'Morisette');

while (my ($idx, $val) = each @bookshelf) {
  say "#$idx $val";
}

my @cats = ('Tulip', 'Misho', 'Murka', 'Charlie');

my @oldest = @cats[-1];
my @youngest = @cats[0..2];
my @selected = @cats[1, 2];

say join ', ', @selected;

say "-------------";

say join ', ', @cats;
@cats[0] = ('Pesho', 'Tulip');

say join ', ', @cats;

say "-------------";

my @sweet_treats = ("pie", "cake", "doughnuts", "cookies", "cinnamon", "roll");

local $" = ')(';
say "(@sweet_treats)";
