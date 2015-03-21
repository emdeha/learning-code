#!/usr/bin/perl

use strict;
use warnings;


my %graph;
my @toFind;

sub createGraph {
    my $fh;
    open($fh, "<", "testDij") 
        or die "Can't open graphFile";

    while (readline $fh) {
        if (/\?/) {
            push @toFind, $_;
        } else {
            my ($par, $node, $cost) = split(" ");
            if (exists $graph{$par}) {
                push @{$graph{$par}}, [$node, $cost];
            } else {
                @{$graph{$par}} = [$node, $cost];
            }
        }
    }
}


# a => (<cost>, <path>)
my %dists;
my %prev;
my @queue;

sub dijkstra {
    for (@toFind) {
        my ($start, $end) = (split " ")[1,2];

        for (@graph) {
            if ($_ ne $start) {
                $prev{$_} = undef;
                $dists{$_} = -1;
            }
            push @queue;
        }

        while (@queue) {
            my $minV;
            for my $key, $val(pairs @dists) {
                if (
            }
        }
    }
}


createGraph();
dijkstra();
