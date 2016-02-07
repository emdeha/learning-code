#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;

package Ver;

our $VERSION = v2.0.0;

sub simple {
  say "I'm a simple package";
}

package main;

Ver->VERSION(1.0.1);
