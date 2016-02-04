#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;


my $call_sign = 'KBMIU';

say $call_sign;
say "------------";

my $next_sign = ++$call_sign;
say $next_sign;
say $call_sign;

say "------------";

my $curr_sign = $call_sign++;
say $curr_sign;
say $call_sign;

say "------------";

my $new_sign = $call_sign + 1;
say $new_sign;
say $call_sign;


say "\n====\n";

my $authors = [qw(Pratchett Vinge Conway)];
my $stringy_ref = '' . $authors;
my $numeric_ref = 0 + $authors;

say $stringy_ref;

say "--------------";

say $numeric_ref;
