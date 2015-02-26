#!/usr/bin/perl -w
# A very, very ugly time format checker.
# Blame Tsvetan Tsvetanov!!!
use strict;

open ( timeTestFile, '+<', "timeTests.txt" );

my $line = "";
while ( $line = <timeTestFile> ) {
	$_ = $line;
	if (( /^(\d{1,2})((:|\n)|(am|pm|\n)|.\n)(\d{1,2})?/ ) &&
		$1 < 24) {
		if ( $5 && $5 > 60 ) {			
		}
		else {
			print $line;
		}
	}
}
