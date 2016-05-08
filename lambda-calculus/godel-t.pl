#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


my $O = 0;

sub S {
  shift() + 1;
}

sub Dec {
  my $x = shift;

  return $x - 1 if $x > 0;
  $x;
}

sub R {
  my ($M, $N, $n) = @_;

  if ($n == 0) {
    return $M;
  } else {
    return $N->(R($M, $N, $n-1))->($n-1);
  }
}

sub D {
  my ($M, $N, $b) = @_;

  return $M if $b;
  return $N;
}

sub Sum {
  my ($x, $y) = @_;

  R($x, sub { my $z = shift; sub { S($z) } }, $y);
}

sub Mult {
  my ($x, $y) = @_;

  R($x, sub { my $z = shift; sub { Sum($x, $z) } }, Dec($y));
}

say Sum(5, 6);
say Mult(5, 6);
say Mult(3, 3);
say Mult(15, 2);
say Mult(0, 1);
say Mult(4, 10);
