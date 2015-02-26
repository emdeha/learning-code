#!/usr/bin/perl -w
use strict;

sub wrong_swap {
	my ($a, $b) = @_;
	my $temp = $a;
	$a = $b;
	$b = $temp;
}

sub right_swap {
	my $temp = $_[0];
	$_[0] = $_[1];
	$_[1] = $temp;
}
