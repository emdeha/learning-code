#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use v5.012;

sub b { say @_ }
sub a { say @_; &b } # '&' passes the args to b. '&' defines that b is a func 
                     # (use strict to test this)

my $coderef = sub { &a };                     
# or my $coderef = \&a;
$coderef->(qw/some params/);
