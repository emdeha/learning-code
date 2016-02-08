#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;

use Data::Dumper;


# That gives me the laughs...
sub bad_greet_one {
  my $name = @_;
  say "Hello, $name; you look numeric today!";
}

bad_greet_one "pesho";

sub modify_name {
  $_[0] = reverse $_[0];
}

my $name = 'Orange';
modify_name($name);
say $name;


call();

sub call {
  show_call_information();
}

sub show_call_information {
  my ($package, $file, $line, $func) = caller(0);
  say "Called from $package in $file:$line";
  say "stack: $func";
}


sub sense_thy_ctx {
  my $ctx = wantarray();

  return qw(List context) if $ctx;
  say 'Void' unless defined $ctx;
  return 'Scalar' unless $ctx
}

sense_thy_ctx();
say my $scalar = sense_thy_ctx();
say sense_thy_ctx();

{
package test;

our $scope;

sub inner {
  say $scope;
}

sub main {
  say $scope;
  local $scope = 'main() scope';
  middle();
}

sub middle {
  say $scope;
  inner();
}

$scope = 'outer scope';
main();
say $scope;
}

# Iterator closure
sub make_iter {
  my @items = @_;
  my $count = 0;

  return sub {
    return if $count == @items;
    return $items[$count++];
  }
}

my $cousins = make_iter(qw(Rick Alex Kaycee Eric Corey Mandy));
say $cousins->() for 1 .. 5;
