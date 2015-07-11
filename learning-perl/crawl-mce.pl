#!/usr/bin/env perl

#
# Gets all pages from a domain
#

use strict;
use warnings;
use v5.020;

use LWP::UserAgent;
use HTML::Parser;
use Data::Dumper;
use Thread::Queue;
use MCE;


my %parsed:shared;
my $to_parse = Thread::Queue->new();

sub fetch_pages($) {
    my $domain = shift;

    my $ua = LWP::UserAgent->new;
    $ua->agent("Crawl/0.1 ");

    my $req = HTTP::Request->new(GET => $domain);
    my $resp = $ua->request($req);

    if ($resp->is_success) {
        my $parser = HTML::Parser->new(api_version => 3);
        $parser->handler(start => \&parse_tag, 'attr, attrseq, text');

        $parser->parse($resp->content);
    } else {
        warn "Parsing $domain failed: " . $resp->status_line;
    }

    my $mce = MCE->new(
        max_workers => 5,
        user_func => 
        sub { 
            while (defined (my $page = $to_parse->dequeue())) {
                do_parse($page);
            }
        }
    );
    $mce->run;
}

sub do_parse {
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
        lock %parsed;
        $parsed{$href} = 1;
        $to_parse->enqueue($href);
    }
}


fetch_pages($ARGV[0]);
