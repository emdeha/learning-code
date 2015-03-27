#!/usr/bin/perl

use strict;
use warnings;

use LWP::Simple;


my $query = $ARGV[0];

my $content = get("http://search.yahoo.com/search;?p=$query");
die "Couldn't get it!" unless defined $content;

my $mrx = qr/<a class=" td-u" href=(.*?) .*?>(.*?)<\/a>/;
while ($content =~ /$mrx/g) {
    my $link = $1;
    my $title = $2;
    $title =~ s/<.+?>//g;
    print "'$title' at\n\t$link\n";
}
