#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;

use Test::More;


my $just_a_cat = qr/cat\b/;
like('my cat', $just_a_cat, 'matching just a cat');

my $safe_feline = qr/cat(?!astrophe)/;
unlike('my catastrophe', $safe_feline, 'doesn not match catastrophic cat');

my $disastrouts_feline = qr/cat(?=astrophe)/;
like('my catastrophe', $disastrouts_feline, 'matches catastrphic cat');

my $words = "cataclysmic - enormous event\ncatastrophe - bad thing\ncataleptic - something\n";
for (split /\n/, $words) {
  next unless /\A(?<cat>$safe_feline.*)\Z/;
  say "Found '$+{cat}'";
}

# Zero-width negative look-begind.  The text mustn't begin with `cat`.
my $middle_cat = qr/(?<!\A)cat/;
like('my cat is back', $middle_cat, 'cat not in begin');
unlike('cat should be back', $middle_cat, 'cat begin');

my $space_cat = qr/(?<=\s)cat/;
like('space cat', $space_cat, 'a signle space before my cat');

# zero-width look-behind assertions must have a fixed size. \K solves this
# problem
my $spacey_cat = qr/\s+\Kcat/;
like('doublespace  cat', $spacey_cat, 'a var space cat');

# Substitute everything from \K onwards
my $exclamation = 'This is a catastrophe!';
say 'before ' . $exclamation;
$exclamation =~ s/cat\K\w+!/./;
say 'after ' . $exclamation;
like($exclamation, qr/\bcat\./, 'that was not so bad');
