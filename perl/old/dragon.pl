#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use Getopt::Std;
use GD::Simple;
use List::Util 'max';

sub usage($) 
{
    my ($err) = @_;

    my $s = 
<<USAGE
Usage: dragon [-m mode] <generation>

    -m    the display mode; use -m list to show available modes
The generation must be a positive integer.
USAGE
    ;

    $err? die($s): print $s;
}

sub version() 
{
    say 'dragon 0.01';
}

sub step($ $ $)
{
    my ($x, $y, $dir) = @_;

    my @steps = ( (0, 1), (1, 0), (0, -1), (-1, 0) );
    my ($dx, $dy) = @steps[2 * $dir, 2 * $dir + 1];

    return ($x + $dx, $y + $dy);
}

sub turn($ $)
{
    my ($dir, $turn) = @_;

    return ($dir - 1 + 2 * $turn) % 4;
}

sub get_coords(@)
{
    my (@turns) = @_;
    my ($x, $y) = (0, 0);
    my $dir = 0;
    my @coords;

    push @coords, ($x, $y);
    ($x, $y) = step $x, $y, $dir;
    push @coords, ($x, $y);

    for my $turn (@turns) {
        $dir = turn $dir, $turn;
        ($x, $y) = step $x, $y, $dir;
        push @coords, ($x, $y);
    }

    return @coords;
}

sub turnsMode(@)
{
    my (@turns) = (@_);

    say @turns;
    exit(0);
}

sub turtleMode(@)
{
    my (@turns) = (@_);

    say 'forward 10';
    for my $turn (@turns) {
        say $turn? 'right': 'left', ' 90';
        say 'forward 10';
    }
    exit(0);
}

sub coordsMode(@)
{
    my (@coords) = (@_);

    my @c;
    while (@coords) {
        my ($x, $y) = (shift @coords, shift @coords);
        push @c, "($x, $y)"
    }
    say "@c";
    exit (0);
}

sub pngMode(@)
{
    my (@coords) = (@_);

    my $maxval = max map { abs($_) } @coords;
    my $scale = 256 / $maxval;

    my $img = GD::Simple->new(600, 600);
    $img->bgcolor('white');
    $img->fgcolor('black');

    $img->moveTo(300, 300);

    while (@coords) {
        my ($x, $y) = (shift @coords, shift @coords);
        my ($imgx, $imgy) = (300 + $scale * $x, 300 - $scale * $y);

        $img->lineTo($imgx, $imgy);
    }

    binmode STDOUT;
    print $img->png;
    exit(0);
}

MAIN:
{
    my %opts;
    getopts('hm:v', \%opts) or usage(1);
    version() if $opts{v};
    usage(0) if $opts{h};
    exit(0) if $opts{h} || $opts{v};

    my $mode = 'turns';
    if (exists($opts{m})) {
        my %modes = (
            'png' => 'Draw a PNG',
            'coords' => 'Coordinates',
            'turns' => 'The sequence as turns',
            'turtle' => 'Turtle graphics'
        );

        if ($opts{m} eq 'list') {
            say 'Available modes:';
            say "$_\t$modes{$_}" for sort keys %modes;
            exit(0);
        }
        usage(1) unless exists $modes{$opts{m}};
        $mode = $opts{m};
    }

    usage(1) unless @ARGV == 1 && $ARGV[0] =~ /^[1-9][0-9]*$/;
    my $generation = $ARGV[0];
    
    my @turns = (1);
    for my $gen (2..$generation) {
        @turns = (@turns, 1, map { 1 - $_ } reverse @turns);
    }

    if ($mode eq 'turns') {
        turnsMode(@turns);
    } elsif ($mode eq 'turtle') {
        turtleMode(@turns);
    }

    my @coords = get_coords @turns;
    if ($mode eq 'coords') {
        coordsMode(@coords);
    }

    if ($mode eq 'png') {
        pngMode(@coords);
    }
}
