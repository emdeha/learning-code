#!/usr/bin/perl
use threads;

use strict;
use warnings;
use v5.020;

use File::Find;
use Thread::Queue;
use List::Util qw/sum/;


die ("Usage: ./par-avg.pl [path] [tcount]")
    if @ARGV < 2;

my $path = $ARGV[0];
my $tcount = $ARGV[1];

my $fileQueue = Thread::Queue->new;
my $avgQueue = Thread::Queue->new;
my $sumQueue = Thread::Queue->new;

my $fileThread = threads->create(sub {
    File::Find::find(sub {
            $fileQueue->enqueue($File::Find::name);
        }, ($path));
    $fileQueue->end;
});

my @chunkThreads;
for (my $i = 0; $i < $tcount; $i++) {
    push @chunkThreads,
        threads->create(
            sub {
                while (defined (my $file = $fileQueue->dequeue)) {
                    open (my $fh, "<", $file)
                        or warn ("Couldn't open file $file")
                            and return;

                    my $chunk;
                    my @favg;
                    while (read $fh, $chunk, 1024) {
                        push @favg,
                            sum (unpack "c*", $chunk) / (1024 * 256);
                    }
                    $avgQueue->enqueue(\@favg);
                }
            });
}

my $sumThread = threads->create(
    sub {
        while (defined (my $avg = $avgQueue->dequeue)) {
            next if scalar @$avg == 0;
            $sumQueue->enqueue(sum (@$avg) / scalar @$avg);
        }
    });

my $printThread = threads->create(
    sub {
        while (defined (my $sum = $sumQueue->dequeue)) {
            print "Sum: $sum\n";
        }
    });

$printThread->join;
$sumThread->join;
map { $_->join } @chunkThreads;
$fileThread->join;
