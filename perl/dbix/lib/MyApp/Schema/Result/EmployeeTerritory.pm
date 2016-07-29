use utf8;
package MyApp::Schema::Result::EmployeeTerritory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::EmployeeTerritory

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<EmployeeTerritories>

=cut

__PACKAGE__->table("EmployeeTerritories");

=head1 ACCESSORS

=head2 employeeid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 territoryid

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "employeeid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "territoryid",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</employeeid>

=item * L</territoryid>

=back

=cut

__PACKAGE__->set_primary_key("employeeid", "territoryid");

=head1 RELATIONS

=head2 employeeid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Employee>

=cut

__PACKAGE__->belongs_to(
  "employeeid",
  "MyApp::Schema::Result::Employee",
  { employeeid => "employeeid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 territoryid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Territory>

=cut

__PACKAGE__->belongs_to(
  "territoryid",
  "MyApp::Schema::Result::Territory",
  { territoryid => "territoryid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KczGtJ5ehUfs+72ScjpRYQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
