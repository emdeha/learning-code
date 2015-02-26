#!/usr/bin/perl -w
# a very, very ugly time format checker.
# blame tsvetan tsvetanov!!!
use strict;

open ( timetestfile, '+<', "timetests.txt" );

my $line = "";
while ( $line = <timetestfile> ) {
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
