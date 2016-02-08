#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;


#
# Cool, but can be better
#
sub gen_fib {
  my @fibs = (0, 1);

  return sub {
    my $item = shift;

    if ($item >= @fibs) {
      for my $calc (@fibs .. $item) {
        $fibs[$calc] = $fibs[$calc - 2] + $fibs[$calc - 1];
      }
    }

    return $fibs[$item];
  }
}

my $fib = gen_fib();
say $fib->(42);


#
# Cooler dooler
#
sub gen_caching_closure {
  my ($calc_element, @cache) = @_;

  return sub {
    my $item = shift;

    if ($item >= @cache) {
      $calc_element->($item, \@cache)
    }

    return $cache[$item];
  }
}

sub gen_fib2 {
  my @fibs = (0, 1, 1);

  return gen_caching_closure(sub {
    my ($item, $fibs) = @_;

    for my $calc ((@fibs - 1) .. $item) {
      $fibs->[$calc] = $fibs->[$calc - 2] + $fibs->[$calc - 1];
    }
  }, @fibs);
}

my $fib2 = gen_fib2();
say $fib2->(42);


#
# Curry the curry
#
sub sum {
  my $s = 0;

  $s += $_ for @_;

  return $s;
}

my $curry = sub {
  return sum(@_, 2, 3);
};

say $curry->(3, 3);
