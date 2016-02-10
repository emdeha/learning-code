#!/usr/bin/env perl

use strict;
use warnings; 
use v5.16;


package Player 
{
  sub new {
    my ($class, %attrs) = @_;
    bless \%attrs, $class;
  }

  sub format {
    my $self = shift;
    return '#' . $self->{number} . ' plays '  . $self->{position};
  }
}

package main;

my $joel = Player->new(number => 10, position => 'center');
my $damian = Player->new(number => 0, position => 'guard');

say $joel->format();
say $damian->format();
