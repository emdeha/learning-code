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


my %table;
my %walked;

sub dijkstra {
    my ($start, $end) = (shift, shift);

    # initialization
    for (keys %graph) {
        $table{$_} = [999999,undef];
    }

    $table{$start} = [0,undef];
    while (keys %walked <=> keys %table) {
        my $minNode = undef;
        for my $key(keys %table) {
            if (not exists $walked{$key}) {
                my $cost = @{$table{$key}}[0];
                my $minCost = 999999;
                if ($cost < $minCost) {
                    $minNode = $key;
                    $minCost = $cost;
                }
            }
        }
        if (defined $minNode) {
            $walked{$minNode} = 1;
        } else {
            print "No path\n";
            return;
        }

        for my $node(@{$graph{$minNode}}) {
            my ($neigh, $cost) = @{$node};
            my $alt = $cost + @{$table{$minNode}}[0];
            if ($alt < @{$table{$neigh}}[0]) {
                @{$table{$neigh}}[0] = $alt;
                @{$table{$neigh}}[1] = $minNode;
            }
        } 
    }

    print "Has path\n";
}


createGraph();
for (@toFind) {
    my @current = split " ", substr $_, 2, 2;
    dijkstra(@current);
}
