#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use lib './lib';
use MyApp::Schema;

my $schema = MyApp::Schema->connect('dbi:SQLite:db/Northwind.db');

my $employees = $schema->resultset('Employee')->search({});
for my $emp ($employees->all) {
  say $emp->title . ' ' . $emp->lastname;
}
