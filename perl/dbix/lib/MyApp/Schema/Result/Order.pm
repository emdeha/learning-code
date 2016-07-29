use utf8;
package MyApp::Schema::Result::Order;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Order

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Orders>

=cut

__PACKAGE__->table("Orders");

=head1 ACCESSORS

=head2 orderid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 customerid

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=head2 employeeid

  data_type: 'integer'
  is_foreign_key: 1
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
  is_foreign_key: 1
  is_nullable: 1

=head2 freight

  data_type: 'numeric'
  default_value: 0
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

=cut

__PACKAGE__->add_columns(
  "orderid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "customerid",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
  "employeeid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "orderdate",
  { data_type => "datetime", is_nullable => 1 },
  "requireddate",
  { data_type => "datetime", is_nullable => 1 },
  "shippeddate",
  { data_type => "datetime", is_nullable => 1 },
  "shipvia",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "freight",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
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
);

=head1 PRIMARY KEY

=over 4

=item * L</orderid>

=back

=cut

__PACKAGE__->set_primary_key("orderid");

=head1 RELATIONS

=head2 customerid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Customer>

=cut

__PACKAGE__->belongs_to(
  "customerid",
  "MyApp::Schema::Result::Customer",
  { customerid => "customerid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 employeeid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Employee>

=cut

__PACKAGE__->belongs_to(
  "employeeid",
  "MyApp::Schema::Result::Employee",
  { employeeid => "employeeid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 order_details

Type: has_many

Related object: L<MyApp::Schema::Result::OrderDetail>

=cut

__PACKAGE__->has_many(
  "order_details",
  "MyApp::Schema::Result::OrderDetail",
  { "foreign.orderid" => "self.orderid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 shipvia

Type: belongs_to

Related object: L<MyApp::Schema::Result::Shipper>

=cut

__PACKAGE__->belongs_to(
  "shipvia",
  "MyApp::Schema::Result::Shipper",
  { shipperid => "shipvia" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:P6qu0BeJFCk5NlYNPPZHuQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
