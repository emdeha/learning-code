#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use GD::Simple;
use List::Util 'max';
use Math::Trig ':pi';

# Dragon curve
# my $init = "FX";
# my %rules = ( 
#     X => "X+YF+",
#     Y => "-FX-Y"
# );
# 
# sub getCoords($)
# {
#     my $grad = $_[0];
#     my $expand = $init;
#     while ($grad-- >= 1) {
#         $expand =~ s/(X|Y)/$rules{$1}/g;
#     }
# 
#     my @coords;
#     my ($x, $y) = (0, 0);
#     my $theta = 0;
#     for (split //, $expand) {
#         if (/F/) {
#             $x += 2 * cos($theta);
#             $y += 2 * sin($theta);
#             push @coords, ($x, $y);
#         } elsif (/\+/) {
#             $theta += pi / 2;
#         } elsif (/\-/) {
#             $theta -= pi / 2;
#         }
#     }
# 
#     return @coords;
# }

# Sierpinski triangle
my $init = "F-G-G";
my %rules = (
    F => "F-G+F+G-F",
    G => "GG"
);

sub getCoords($)
{
     my $grad = $_[0];
     my $expand = $init;
     while ($grad-- >= 1) {
         $expand =~ s/(G|F)/$rules{$1}/g;
     }

     my @coords;
     my ($x, $y) = (0, 0);
     my $theta = 0;
     for (split //, $expand) {
         if (/F|G/) {
             $x += 2 * cos($theta);
             $y += 2 * sin($theta);
             push @coords, ($x, $y);
         } elsif (/\+/) {
             $theta -= 2 * pi / 3;
         } elsif (/\-/) {
             $theta += 2 * pi / 3;
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
