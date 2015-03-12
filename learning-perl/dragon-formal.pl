#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use Getopt::Std;
use GD::Simple;
use List::Util 'max';
use Math::Trig ':pi';

# Dragon curve
my $dInit = "FX";
my $dAngle = pi / 2;
my $dRight = qr/\+/;
my $dLeft = qr/\-/;
my $dFwd = qr/F/;
my $dExp = qr/(X|Y)/;
my %dRules = ( 
    X => "X+YF+",
    Y => "-FX-Y"
);

# Sierpinski triangle
my $sInit = "F-G-G";
my $sAngle = 2 * pi / 3;
my $sRight = qr/\-/;
my $sLeft = qr/\+/;
my $sFwd = qr/F|G/;
my $sExp = qr/(G|F)/;
my %sRules = (
    F => "F-G+F+G-F",
    G => "GG"
);

sub getCoords($ $)
{
     my ($grad, $figure) = @_;

     my $left = $dLeft;
     my $right = $dRight;
     my $fwd = $dFwd;
     my $angle = $dAngle;
     my $init = $dInit;
     my %rules = %dRules;
     my $exp = $dExp;
     if ($figure eq 'sierp') {
         $left = $sLeft;
         $right = $sRight;
         $fwd = $sFwd;
         $angle = $sAngle;
         $init = $sInit;
         %rules = %sRules;
         $exp = $sExp;
     }

     my $expand = $init;
     while ($grad-- >= 1) {
         $expand =~ s/$exp/$rules{$1}/g;
     }

     my @coords;
     my ($x, $y) = (0, 0);
     my $theta = 0;
     for (split //, $expand) {
         if (/$fwd/) {
             $x += 2 * cos($theta);
             $y += 2 * sin($theta);
             push @coords, ($x, $y);
         } elsif (/$right/) {
             $theta += $angle;
         } elsif (/$left/) {
             $theta -= $angle;
         }
     }

     return @coords;
}

sub draw(@)
{
    my @coords = @_;

    my $img = GD::Simple->new(600, 600);
    $img->bgcolor('white');
    $img->fgcolor('black');

    $img->moveTo(300, 300);

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

sub version()
{
    say 'Dragon Formal v0.1'
}

sub usage($_)
{
    my ($err) = @_;

    my $s = <<USAGE
Usage: dragon-formal [-f figure] <generation>

    -f     the figure which you want to draw; use -f list to show available figures
The generation must be positive integer
USAGE
    ;

    $err? die($s): print $s;
}

MAIN:
{
    my %opts;
    getopts('hf:v', \%opts) or usage(1);
    version() if $opts{v};
    usage(0) if $opts{h};
    exit(0) if $opts{h} || $opts{v};

    my $figure = 'dragon';
    if (exists($opts{f})) {
        my %figures = (
            'dragon' => "Draw Dragon curve",
            'sierp' => "Draw Sierpinski triange",
        );

        if ($opts{f} eq 'list') {
            say 'Available figures:';
            say "$_\t$figures{$_}" for sort keys %figures;
            exit(0);
        }
        usage(1) unless exists $figures{$opts{f}};
        $figure = $opts{f};
    }

    usage(1) unless @ARGV == 1 && $ARGV[0] =~ /^[1-9][0-9]*$/;
    my $generation = $ARGV[0];

    my @coords = getCoords($generation, $figure);
    draw(@coords);
}
