use utf8;
package MyApp::Schema::Result::Supplier;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Supplier

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Suppliers>

=cut

__PACKAGE__->table("Suppliers");

=head1 ACCESSORS

=head2 supplierid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 companyname

  data_type: 'text'
  is_nullable: 0

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

=head2 homepage

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "supplierid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "companyname",
  { data_type => "text", is_nullable => 0 },
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
  "homepage",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</supplierid>

=back

=cut

__PACKAGE__->set_primary_key("supplierid");

=head1 RELATIONS

=head2 products

Type: has_many

Related object: L<MyApp::Schema::Result::Product>

=cut

__PACKAGE__->has_many(
  "products",
  "MyApp::Schema::Result::Product",
  { "foreign.supplierid" => "self.supplierid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jbXQtgDDyDHbdw2hHZleug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
