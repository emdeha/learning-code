#!/usr/bin/perl

use warnings;
use strict;
use 5.012;


my %foundSizes;

sub fileSearch 
{
    my $dir = shift;

    opendir(my $dh, $dir) or die("Cannot open dir G:/Vim");
    while (readdir $dh) {
        my $filePath = "$dir/$_";

        if (-f $filePath) {
            my @stats = stat $filePath;
            $foundSizes{$_} = $stats[7];
        } elsif ($_ cmp "." and $_ cmp "..") {
            fileSearch($filePath);
        }
    }
    closedir($dh);
}

fileSearch("G:/MOVIES");

for (sort keys %foundSizes) {
    say "$_ => $foundSizes{$_}";
}
