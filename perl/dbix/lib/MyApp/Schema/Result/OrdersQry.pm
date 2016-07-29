use utf8;
package MyApp::Schema::Result::OrdersQry;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::OrdersQry

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Orders Qry">

=cut

__PACKAGE__->table(\"\"Orders Qry\"");

=head1 ACCESSORS

=head2 orderid

  data_type: 'integer'
  is_nullable: 1

=head2 customerid

  data_type: 'text'
  is_nullable: 1

=head2 employeeid

  data_type: 'integer'
  is_nullable: 1

=head2 orderdate

  data_type: 'datetime'
  is_nullable: 1

=head2 requireddate

  data_type: 'datetime'
  is_nullable: 1

=head2 shippeddate

  data_type: 'datetime'
  is_nullable: 1

=head2 shipvia

  data_type: 'integer'
  is_nullable: 1

=head2 freight

  data_type: 'numeric'
  is_nullable: 1

=head2 shipname

  data_type: 'text'
  is_nullable: 1

=head2 shipaddress

  data_type: 'text'
  is_nullable: 1

=head2 shipcity

  data_type: 'text'
  is_nullable: 1

=head2 shipregion

  data_type: 'text'
  is_nullable: 1

=head2 shippostalcode

  data_type: 'text'
  is_nullable: 1

=head2 shipcountry

  data_type: 'text'
  is_nullable: 1

=head2 companyname

  data_type: 'text'
  is_nullable: 1

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 city

  data_type: 'text'
  is_nullable: 1

=head2 region

  data_type: 'text'
  is_nullable: 1

=head2 postalcode

  data_type: 'text'
  is_nullable: 1

=head2 country

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "orderid",
  { data_type => "integer", is_nullable => 1 },
  "customerid",
  { data_type => "text", is_nullable => 1 },
  "employeeid",
  { data_type => "integer", is_nullable => 1 },
  "orderdate",
  { data_type => "datetime", is_nullable => 1 },
  "requireddate",
  { data_type => "datetime", is_nullable => 1 },
  "shippeddate",
  { data_type => "datetime", is_nullable => 1 },
  "shipvia",
  { data_type => "integer", is_nullable => 1 },
  "freight",
  { data_type => "numeric", is_nullable => 1 },
  "shipname",
  { data_type => "text", is_nullable => 1 },
  "shipaddress",
  { data_type => "text", is_nullable => 1 },
  "shipcity",
  { data_type => "text", is_nullable => 1 },
  "shipregion",
  { data_type => "text", is_nullable => 1 },
  "shippostalcode",
  { data_type => "text", is_nullable => 1 },
  "shipcountry",
  { data_type => "text", is_nullable => 1 },
  "companyname",
  { data_type => "text", is_nullable => 1 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "city",
  { data_type => "text", is_nullable => 1 },
  "region",
  { data_type => "text", is_nullable => 1 },
  "postalcode",
  { data_type => "text", is_nullable => 1 },
  "country",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uWgpiyL9YmZ6Rm0x44DT9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
