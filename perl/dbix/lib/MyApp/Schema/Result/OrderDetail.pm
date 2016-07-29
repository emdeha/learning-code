use utf8;
package MyApp::Schema::Result::OrderDetail;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::OrderDetail

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<"Order Details">

=cut

__PACKAGE__->table(\"\"Order Details\"");

=head1 ACCESSORS

=head2 orderid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 productid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 unitprice

  data_type: 'numeric'
  default_value: 0
  is_nullable: 0

=head2 quantity

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=head2 discount

  data_type: 'real'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "orderid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "productid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "unitprice",
  { data_type => "numeric", default_value => 0, is_nullable => 0 },
  "quantity",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
  "discount",
  { data_type => "real", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</orderid>

=item * L</productid>

=back

=cut

__PACKAGE__->set_primary_key("orderid", "productid");

=head1 RELATIONS

=head2 orderid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Order>

=cut

__PACKAGE__->belongs_to(
  "orderid",
  "MyApp::Schema::Result::Order",
  { orderid => "orderid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 productid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "productid",
  "MyApp::Schema::Result::Product",
  { productid => "productid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wDnvRovoGhhZQ7LTLpa10Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
