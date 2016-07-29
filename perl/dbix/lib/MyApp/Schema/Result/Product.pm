use utf8;
package MyApp::Schema::Result::Product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Product

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Products>

=cut

__PACKAGE__->table("Products");

=head1 ACCESSORS

=head2 productid

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 productname

  data_type: 'text'
  is_nullable: 0

=head2 supplierid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 categoryid

  data_type: 'integer'
  is_nullable: 1

=head2 quantityperunit

  data_type: 'text'
  is_nullable: 1

=head2 unitprice

  data_type: 'numeric'
  default_value: 0
  is_nullable: 1

=head2 unitsinstock

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 unitsonorder

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 reorderlevel

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 discontinued

  data_type: 'text'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "productid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
  },
  "productname",
  { data_type => "text", is_nullable => 0 },
  "supplierid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "categoryid",
  { data_type => "integer", is_nullable => 1 },
  "quantityperunit",
  { data_type => "text", is_nullable => 1 },
  "unitprice",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "unitsinstock",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "unitsonorder",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "reorderlevel",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "discontinued",
  { data_type => "text", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</productid>

=back

=cut

__PACKAGE__->set_primary_key("productid");

=head1 RELATIONS

=head2 order_details

Type: has_many

Related object: L<MyApp::Schema::Result::OrderDetail>

=cut

__PACKAGE__->has_many(
  "order_details",
  "MyApp::Schema::Result::OrderDetail",
  { "foreign.productid" => "self.productid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 productid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Category>

=cut

__PACKAGE__->belongs_to(
  "productid",
  "MyApp::Schema::Result::Category",
  { categoryid => "productid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 supplierid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Supplier>

=cut

__PACKAGE__->belongs_to(
  "supplierid",
  "MyApp::Schema::Result::Supplier",
  { supplierid => "supplierid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3ctMeqsUifx+eKGEhjA8Cg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
