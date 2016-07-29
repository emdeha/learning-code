use utf8;
package MyApp::Schema::Result::Shipper;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Shipper

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Shippers>

=cut

__PACKAGE__->table("Shippers");

=head1 ACCESSORS

=head2 shipperid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 companyname

  data_type: 'text'
  is_nullable: 0

=head2 phone

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "shipperid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "companyname",
  { data_type => "text", is_nullable => 0 },
  "phone",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</shipperid>

=back

=cut

__PACKAGE__->set_primary_key("shipperid");

=head1 RELATIONS

=head2 orders

Type: has_many

Related object: L<MyApp::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "MyApp::Schema::Result::Order",
  { "foreign.shipvia" => "self.shipperid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iZK1S6I3JMc59sV1hC5DiQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
