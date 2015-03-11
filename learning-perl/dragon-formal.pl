#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use GD::Simple;
use List::Util 'max';

my $angle = 90;
my $init = "FX";
my @consts = ('F', '+', '-');
my %rules = ( 
    X => "X+YF+",
    Y => "-FX-Y"
);

sub getCoords($)
{
    my $grad = $_[0];
    my $expand = $init;
    while ($grad-- >= 1) {
        $expand =~ s/(X|Y)/$rules{$1}/g;
    }

    my @split = split '', $expand;
    my @coords;
    my ($x, $y) = (1, 0);
    for (@split) {
        if ($_ cmp 'F') {
            push @coords, (10 * $x, 10 * $y);
        } elsif ($_ cmp '+') {
        } elsif ($_ cmp '-') {
        }
    }
    # $, = ' ';
    # say @coords;

    return @coords;
}

MAIN:
{
    my $img = GD::Simple->new(600, 600);
    $img->bgcolor('white');
    $img->fgcolor('black');

    $img->moveTo(300, 300);

    my @coords = getCoords(8);
    my $maxval = max map { abs($_) } @coords;
    my $scale = 256 / $maxval;
    while (@coords) {
        my ($x, $y) = (shift @coords, shift @coords);
        my ($imgx, $imgy) = (300 + $scale * $x, 300 - $scale * $y);

        $img->lineTo($imgx, $imgy);

    }

    binmode STDOUT;
    print $img->png;
    exit(0);
}
