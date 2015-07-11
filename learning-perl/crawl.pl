#!/usr/bin/env perl

#
# Gets all pages from a domain
#

use forks;
use forks::shared;
use strict;
use warnings;
use v5.020;

use LWP::UserAgent;
use HTML::Parser;
use Data::Dumper;
use Thread::Queue;
use URI;


my %parsed:shared;
my $max_threads = 10;
my $to_parse:shared;
$to_parse = Thread::Queue->new();
my $base = get_auth($ARGV[0]);

sub get_auth {
    my $url = shift;

    my(undef, $authority, undef, undef, undef) =
    $url =~ m|(?:([^:/?#]+):)?(?://([^/?#]*))?([^?#]*)(?:\?([^#]*))?(?:#(.*))?|;

    return $authority;
}

sub fetch_pages($) {
    my $domain = shift;

    my $ua = LWP::UserAgent->new;
    $ua->agent("Crawl/0.1 ");

    my $req = HTTP::Request->new(GET => $domain);
    my $resp = $ua->request($req);

    if ($resp->is_success) {
        my $parser = HTML::Parser->new(api_version => 3);
        $parser->handler(start => \&parse_tag, 'attr, attrseq, text');

        # TODO: Put links from that shit to child processes
        $parser->parse($resp->content);
    } else {
        warn "Parsing $domain failed: " . $resp->status_line;
    }
}

sub do_parse {
    BEG:
    while ($to_parse->pending()) {
        next if threads->list(threads::running) >= $max_threads;

        my $page = $to_parse->dequeue();
        next if defined $page 
            and $page !~ /^http[^s].*$/ or 
                get_auth($page) !~ /\Q$base\E/;
        threads->create(sub {
            parse_page($page);
        });
    }
    goto BEG;
}

sub parse_page {
    my $page = shift;

    my $ua = LWP::UserAgent->new;
    $ua->agent("Crawl/0.1 ");

    my $req = HTTP::Request->new(GET => $page);
    my $resp = $ua->request($req);

    if ($resp->is_success) {
        print "In $page\n";
        fetch_pages($page);
    } else {
        warn "Parsing $page failed: " . $resp->status_line;
    }
}

sub parse_tag($$$) {
    my ($attr, undef, undef) = @_;

    my $href = $attr->{href}
        if exists $attr->{href};

    # TODO: Clean $domain
    my $domain = $ARGV[0];
    if (defined $href and
            not exists $parsed{$href}) {
        {
            lock %parsed;
            $parsed{$href} = 1;
        }
        $to_parse->enqueue($href);
    }
}


$to_parse->enqueue($ARGV[0]);
do_parse();
map { $_->join } threads->list(threads::running);
# $to_parse->enqueue(undef) for (0..$#threads);
# map { $_->join } @threads;
