#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use List::Util qw/reduce any all/;

use v5.012;


my @ary = ( 1, 2, 3, 4, 5, 6, 7, 8 );

say 'some bigger than 5' if any { $_ > 5 } @ary;
say 'all are positive' if all { $_ > 0 } @ary;

any { $_ & 1 } @ary and say 'some elements are odd';

say reduce { $a + $b } @ary;
