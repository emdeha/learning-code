#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use GD::Simple;
use List::Util 'max';
use constant halfpi => atan2(1, 0);

my $init = "FX";
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

    my @coords;
    my ($x, $y) = (0, 0);
    my $theta = 0;
    for (split //, $expand) {
        if (/F/) {
            $x += 2 * cos($theta);
            $y += 2 * sin($theta);
            push @coords, ($x, $y);
        } elsif (/\+/) {
            $theta += halfpi;
        } elsif (/\-/) {
            $theta -= halfpi;
        }
    }

    return @coords;
}

MAIN:
{
    my $img = GD::Simple->new(600, 600);
    $img->bgcolor('white');
    $img->fgcolor('black');

    $img->moveTo(300, 300);

    my @coords = getCoords(10);
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
