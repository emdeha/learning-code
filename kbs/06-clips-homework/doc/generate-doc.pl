#!/usr/bin/env perl

use v5.14;
use strict;
use warnings;

use File::Slurp;


my $usage = <<"USE";

  generate-doc.pl <doc_name> <source_file>

    doc_name
    - the name of the doc to generate
  
    source_file
    - the name of the source file for which to generate a doc

SYNOPSIS:
  
  `generate-doc` generates LaTeX documentation for my KBS project.

DESCRIPTION:

  `generate-doc` uses `header.txt` to generate the LaTeX headers.  It then 
  uses `title.txt` to generate the title page.  After that, it parses 
  <source_file> and generates the rest of the doc based on its contents.
USE


print $usage if @ARGV < 2;


my $out = $ARGV[0];
my $in = $ARGV[1];


my $header = read_file("header.txt");
my $title = read_file("title.txt");

my $begin = <<"BEG";

\\begin{document}

\\maketitle
\\thispagestyle{empty}
\\newpage

BEG

my $end = <<"END";

\\end{document}
END


my %getname = (
  defrule => 'правило',
  deffunction => 'функция',
);

my $text = "";

my @source = read_file($in);
my $i = 0;

my $empty = qr/;\s*(\n|\n\r|\r)/;
my $defsth = qr/\((defrule|deffunction) ([a-z-]+)\s*/;

while ($i < @source) {
  # Section or paragraph
  if ($source[$i] =~ $empty) {
    my $buf;
SEC_PAR:
    $i++;

    if ($source[$i] =~ /;\s*(.*)/) {
      my $t = $1;
      if ($source[$i+1] =~ $empty && $source[$i-1] =~ $empty) {
        $text .= "\\section{$t}\n";
        $buf = "";
      } else {
        if ($source[$i+1] =~ $defsth) {
          my $func .= "\\begin{verbatim}$getname{$1} $2\\end{verbatim}\n";
          $buf = $func . $buf;
        }
        $buf .= $t . "\n";
      }

      goto SEC_PAR;
    }

    $text .= $buf;
  } elsif ($source[$i] =~ /;\s*(.*)/) {
    my $buf = "";
FUNC_NAME:
    if ($source[$i] =~ /;\s*(.*)/) {
      my $t = $1;
      if ($source[$i+1] =~ $defsth) {
        my $func = "\\begin{verbatim}$getname{$1} $2\\end{verbatim}\n";
        $buf = $func . $buf;
      }
      $buf .= "\n" . $t;

      $i++;

      goto FUNC_NAME;
    } 

    $text .= $buf . "\n";
  }

  $i++;
}


write_file("$out.tex", ($header, $title, $begin, $text, $end));
