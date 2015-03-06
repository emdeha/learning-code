#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use Getopt::Std;

sub usage($) {
    my ($err) = @_;

    my $s = 
<<USAGE
Usage: dragon [-m mode] <generation>

    -m    the display mode (turns, turtle)
The generation must be a positive integer.
USAGE
    ;

    $err? die($s): print $s;
}

sub version() {
    say 'dragon 0.01';
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
        say @turns;
    } elsif ($mode eq 'turtle') {
        say 'forward 10';
        for my $turn (@turns) {
            say $turn? 'right': 'left', ' 90';
            say 'forward 10';
        }
    }
}
