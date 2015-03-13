#!/usr/bin/perl

use strict;
use warnings;
use utf8;

my $bstr = $ARGV[0] || "ds[dsds[(asd)]]";

my %bmatch = qw/( ) [ ] { }/;
my %rmatch = qw/) ( ] [ } {/;

my @s;

for my $pos (1..length($bstr)) {
    my $c = substr $bstr, $pos - 1, 1;

    exists $bmatch{$c}
        and push @s, $c;

    if ($rmatch{$c}) {
        scalar(@s) or die "too many closing";
        $bmatch{pop @s} eq $c or die "mismatch";
    }
}

scalar @s and die "mismatch";

print "OK!"
