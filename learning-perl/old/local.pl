#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use v5.012;

$_ = 'LA';

say $_;

{
    local $_;

    $_ .= 'RO';
    say $_;
}

say $_;

{
    $_ .= 'DEE';
    say $_;
}

say $_;
