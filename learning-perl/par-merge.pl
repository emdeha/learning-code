#!/usr/bin/env perl

use strict;
use threads;
use threads::shared;
use warnings;
use v5.020;


my $beg_size;

sub mergesort_number
{
	my ($aref, $begin, $end)=@_;

	my $size=$end-$begin;

	if($size<2) {return;}
	my $half=$begin+int($size/2);

    my $th1;
    my $th2;
    if ($size < $beg_size) {
        $th1 = threads->create( sub { mergesort_number($aref, $begin, $half) });
        $th2 = threads->create( sub { mergesort_number($aref, $half, $end) });
    } else {
        mergesort_number($aref, $begin, $half);
        mergesort_number($aref, $half, $end);
    }

    if (defined $th1 && defined $th2) {
        $th1->join;
        $th2->join;
    }

	for(my $i=$begin; $i<$half; ++$i) {
		if($$aref[$i] > $$aref[$half]) {
			my $v=$$aref[$i];
			$$aref[$i]=$$aref[$half];

			my $i=$half;
			while($i<$end-1 && $$aref[$i+1] < $v) {
				($$aref[$i], $$aref[$i+1])=
					($$aref[$i+1], $$aref[$i]);
				++$i;
			}
			$$aref[$i]=$v;
		}
	}
}


my @arr;
@arr = (2,3,4,5,1,2,3,45,4,3,3,3,3,3,3);
$beg_size = scalar (@arr) / 2;
mergesort_number(\@arr, 0, scalar (@arr));
print "$_," for (@arr);
