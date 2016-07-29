use utf8;
package MyApp::Schema::Result::CustomerCustomerDemo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::CustomerCustomerDemo

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<CustomerCustomerDemo>

=cut

__PACKAGE__->table("CustomerCustomerDemo");

=head1 ACCESSORS

=head2 customerid

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 customertypeid

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "customerid",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "customertypeid",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</customerid>

=item * L</customertypeid>

=back

=cut

__PACKAGE__->set_primary_key("customerid", "customertypeid");

=head1 RELATIONS

=head2 customerid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Customer>

=cut

__PACKAGE__->belongs_to(
  "customerid",
  "MyApp::Schema::Result::Customer",
  { customerid => "customerid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 customertypeid

Type: belongs_to

Related object: L<MyApp::Schema::Result::CustomerDemographic>

=cut

__PACKAGE__->belongs_to(
  "customertypeid",
  "MyApp::Schema::Result::CustomerDemographic",
  { customertypeid => "customertypeid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FnMHMSTIBrjALI/kGtZvNA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
