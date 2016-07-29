use utf8;
package MyApp::Schema::Result::OrderDetailsExtended;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::OrderDetailsExtended

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Order Details Extended">

=cut

__PACKAGE__->table(\"\"Order Details Extended\"");

=head1 ACCESSORS

=head2 orderid

  data_type: 'integer'
  is_nullable: 1

=head2 productid

  data_type: 'integer'
  is_nullable: 1

=head2 productname

  data_type: 'text'
  is_nullable: 1

=head2 unitprice

  data_type: 'numeric'
  is_nullable: 1

=head2 quantity

  data_type: 'integer'
  is_nullable: 1

=head2 discount

  data_type: 'real'
  is_nullable: 1

=head2 extendedprice

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "orderid",
  { data_type => "integer", is_nullable => 1 },
  "productid",
  { data_type => "integer", is_nullable => 1 },
  "productname",
  { data_type => "text", is_nullable => 1 },
  "unitprice",
  { data_type => "numeric", is_nullable => 1 },
  "quantity",
  { data_type => "integer", is_nullable => 1 },
  "discount",
  { data_type => "real", is_nullable => 1 },
  "extendedprice",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8CHX5Do/FWnMq7CGqu1RHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
