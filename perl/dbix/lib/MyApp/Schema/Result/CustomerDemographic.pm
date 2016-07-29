use utf8;
package MyApp::Schema::Result::CustomerDemographic;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::CustomerDemographic

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<CustomerDemographics>

=cut

__PACKAGE__->table("CustomerDemographics");

=head1 ACCESSORS

=head2 customertypeid

  data_type: 'text'
  is_nullable: 0

=head2 customerdesc

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "customertypeid",
  { data_type => "text", is_nullable => 0 },
  "customerdesc",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</customertypeid>

=back

=cut

__PACKAGE__->set_primary_key("customertypeid");

=head1 RELATIONS

=head2 customer_customer_demos

Type: has_many

Related object: L<MyApp::Schema::Result::CustomerCustomerDemo>

=cut

__PACKAGE__->has_many(
  "customer_customer_demos",
  "MyApp::Schema::Result::CustomerCustomerDemo",
  { "foreign.customertypeid" => "self.customertypeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 customerids

Type: many_to_many

Composing rels: L</customer_customer_demos> -> customerid

=cut

__PACKAGE__->many_to_many("customerids", "customer_customer_demos", "customerid");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AHrV91312Il5tcvfIHwvtA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
