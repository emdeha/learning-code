#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;

use Data::Dumper;


#
# Arrays:
#
# Use backslash to create a ref to a named array
my @named_arr = ("ad", "sad", "grad");
my $named_ref = \@named_arr;

# Square brackets to create a ref to an anonymous array
my $arr = [1, 2, [3, 4, 5]];

say Dumper(${ @{ $arr }[2] }[1]);

# Square brackets make a reference to a copy
my @meals = qw(soup sandwiches pizza);
my $sunday_ref = \@meals;

say "backslash";
say "before: " . Dumper $sunday_ref;

push @meals, 'cherry pie';

say "after: " . Dumper $sunday_ref;

my $monday_ref = [ @meals ];

say "square brackets";
say "before: " . Dumper $monday_ref;

push @meals, 'suite pee';

say "after: " . Dumper $monday_ref;

push @$monday_ref, 'parmejano';

say "meals: " . Dumper @meals;
say "monday_ref: " . Dumper @$monday_ref;

#
# Autovivification
#
my @aoaoaoa;
$aoaoaoa[0][0][0][0] = 'nested deeply';

say "deep: " . Dumper @aoaoaoa;

my %hohoh;
$hohoh{Robot}{Santa} = 'mostly harmful';

say "harm: " . Dumper %hohoh;

#
# Circular references
#
use Scalar::Util 'weaken';

my $cianne;
{
my $alice  = { mother => '', father => '' };
my $robin  = { mother => '', father => '' };
$cianne = { mother => $alice, father => $robin };

push @{ $alice->{children} }, $cianne;
push @{ $robin->{childern} }, $cianne;
}

say "not weaker: " . Dumper $cianne;

weaken( $cianne->{mother} );
weaken( $cianne->{father} );

say "weaker: " . Dumper $cianne;

#
# Sort by ranks
#
my $i = 0;
my %rank;
for ( qw(lead wife son daughter pal pet) ) { $rank{$_} = ++$i };

my %HoH = (
  flintstones => {
    lead => "fred",
    pal => "barney",
  },
  jetsons => {
    lead => "george",
    wife => "jane",
  },
  simpsons => {
    lead => "homer",
    wife => "marge",
    son => "bart",
  },
);

for my $family ( sort { keys %{$HoH{$b}} <=> keys %{$HoH{$a}} } keys %HoH ) {
  print "$family: { ";
  for my $role ( sort { $rank{$a} <=> $rank{$b} } keys %{ $HoH{$family} } ) {
    print "$role=$HoH{$family}{$role} ";
  }
  print "}\n";
}
