use utf8;
package MyApp::Schema::Result::Customer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Customer

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Customers>

=cut

__PACKAGE__->table("Customers");

=head1 ACCESSORS

=head2 customerid

  data_type: 'text'
  is_nullable: 0

=head2 companyname

  data_type: 'text'
  is_nullable: 1

=head2 contactname

  data_type: 'text'
  is_nullable: 1

=head2 contacttitle

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

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 fax

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "customerid",
  { data_type => "text", is_nullable => 0 },
  "companyname",
  { data_type => "text", is_nullable => 1 },
  "contactname",
  { data_type => "text", is_nullable => 1 },
  "contacttitle",
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
  "phone",
  { data_type => "text", is_nullable => 1 },
  "fax",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</customerid>

=back

=cut

__PACKAGE__->set_primary_key("customerid");

=head1 RELATIONS

=head2 customer_customer_demos

Type: has_many

Related object: L<MyApp::Schema::Result::CustomerCustomerDemo>

=cut

__PACKAGE__->has_many(
  "customer_customer_demos",
  "MyApp::Schema::Result::CustomerCustomerDemo",
  { "foreign.customerid" => "self.customerid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 orders

Type: has_many

Related object: L<MyApp::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "MyApp::Schema::Result::Order",
  { "foreign.customerid" => "self.customerid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 customertypeids

Type: many_to_many

Composing rels: L</customer_customer_demos> -> customertypeid

=cut

__PACKAGE__->many_to_many("customertypeids", "customer_customer_demos", "customertypeid");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:b0Pse+EDW2m7qJ0pgLSoNw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
