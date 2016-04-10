#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


# 
# Utility functions
sub cprint {
  my $n = shift;

  $n->(sub { $_[0] + 1 })->(0);
}

sub repeat {
  my ($n, $f, $x) = @_;

  return $x if $n == 0;

  $f->(repeat($n-1, $f, $x));
}

#
# Church numerals
sub c {
  my $n = shift;

  sub { my $f = shift;
    sub { my $x = shift;

      repeat($n, $f, $x);
    }
  }
}

sub cs {
  my $n = shift;

  sub { my $f = shift;
    sub { my $x = shift;

      $f->($n->($f), $x);
    }
  }
}

sub cplus {
  my $n = shift;

  sub { my $m = shift;
    sub { my $f = shift;
      sub { my $x = shift;

        ($m->($f))->(($n->($f))->($x));
      }
    }
  }
}

sub cmult {
  my $n = shift;

  sub { my $m = shift;
    sub { my $f = shift;
      sub { my $x = shift;

        ($m->($n->($f)))->($x);
      }
    }
  }
}

sub cexp {
  my $n = shift;

  sub { my $m = shift;
    sub { my $f = shift;
      sub { my $x = shift;

        (($n->($m))->($f))->($x);
      }
    }
  }
}

sub chyp {
  my $n = shift;

  sub { my $m = shift;
    sub { my $f = shift;
      sub { my $x = shift;

        (($n->(cexp($m)))->($m))->($f)->($x);
      }
    }
  }
}

#
# Tests
say cprint(c(2));
say cprint(cplus(c(2))->(c(4)));
say cprint(cmult(c(2))->(c(4)));
say cprint(cexp(c(2))->(c(4)));

say cprint(chyp(c(4))->(c(2)));
