#!/usr/bin/perl

use strict;
use warnings;


my %graph;
my @toFind;

sub createGraph {
    my $fh;
    open($fh, "<", "testGraph") 
        or die "Can't open graphFile";

    while (readline $fh) {
        if (/\?/) {
            push @toFind, $_;
        } else {
            my @splitted = split(":", $_);
            if ($splitted[0]) {
                my @rest = split(" ", $splitted[1]);
                for (@rest) {
                    push @{$graph{$splitted[0]}}, $_;
                }
            }
        }
    }
}

my %walked;
my @queue;

sub bfs {
    for (@toFind) {
        my @split = split " ";
        my ($start, $end) = ($split[1], $split[2]);

        push @queue, $start;
        $walked{$start} = 'yes';
        while (@queue) {
            my $curr = shift @queue;
            if ($curr eq $end) {
                print "FOUND!";
                return;
            }
            for (@{$graph{$curr}}) {
                if (!exists($walked{$curr})) {
                    print "not exists";
                    push @queue, $curr;
                    $walked{$curr} = 'yes';
                }
            }
        }
    }
}

createGraph();
bfs();
