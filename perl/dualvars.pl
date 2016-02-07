#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;


use Scalar::Util qw/dualvar/;

my $false_name = dualvar 0, 'Sparkles & Blue';

say 'Boolean true!' if !!$false_name;
say 'Numeric false!' unless 0 - $false_name;
say 'String true!' if '' . $false_name;

say $false_name;
