#!/usr/bin/env perl
use forks;

use strict;
use warnings;
use v5.20;

use File::Find;
use Thread::Queue;


die ("Usage: par-grep.pl [regex] [path] [tcount]")
    if @ARGV < 3;

my $regex = $ARGV[0];
my $path = $ARGV[1];
my $tCount = $ARGV[2];

# File::Find::find(sub {
#         open (my $fh, "<", $_)
#             or warn ("Couldn't open file $_")
#                 and return;
# 
#         for my $line (<$fh>) {
#             print "Matched $regex at $_\n"
#                 if $line =~ m/$regex/;
#         }
#     }, ($path));

my $fileQueue;
$fileQueue = Thread::Queue->new;

my $finderThread = threads->create(sub {
    File::Find::find(sub {
            $fileQueue->enqueue($File::Find::name);
        }, ($path));
    $fileQueue->end;
});

my @regexThreads;
for (my $i = 0; $i < $tCount; $i++) {
    push @regexThreads,
        threads->create(
        sub {
            while (defined (my $file = $fileQueue->dequeue_nb)) {
                open (my $fh, "<", $file)
                    or warn ("Couldn't open file $file")
                        and return;

                for my $line (<$fh>) {
                    print "Matched $regex at $file\n"
                        if $line =~ m/$regex/;
                }
            }
        });
}

map { $_->join } @regexThreads;


# sub wanted {
#     if ($#regexThreads < 8) {
#         push @regexThreads,
#         threads->create(sub {
#             open (my $fh, "<", $_)
#                 or warn ("Couldn't open file $_") 
#                     and return;
# 
#             for my $line (<$fh>) {
#                 print "Matched $regex at $_\n"
#                     if $line =~ m/$regex/;
#             }
#         });
#     }
# 
#     #grep { not $_->is_running } @regexThreads;
#     @regexThreads = grep { $_->is_running } @regexThreads;
# }
# 
# for (@regexThreads) {
#     $_->join;
# }
