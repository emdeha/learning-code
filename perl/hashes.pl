#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;


my %addresses = (
  Leonardo => '1123 Fib Place',
  Utako    => 'Cantor Hotel, Room 1',
);

sub get_address_from_name {
  return $addresses{+shift};
}

say get_address_from_name 'Leonardo';

my @items = (1, 3, 1, 1, 2, 3, 2, 4, 1, 4, 5, 3, 3);

my %uniq;
undef @uniq{@items};
my @uniques = keys %uniq;

local $" = " ";
say @uniques;

{
  my %user_cache = (
    Pesho => 1,
    Gosho => 2,
  );

  sub fetch_user {
    my $id = shift;
    $user_cache{$id} //= create_user($id);
    return $user_cache{$id};
  }

  sub create_user {
    my $id = shift;
    return length($id);
  }

  say fetch_user("vlady");
  say fetch_user("Pesho");
}
