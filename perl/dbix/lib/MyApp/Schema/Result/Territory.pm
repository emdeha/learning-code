use utf8;
package MyApp::Schema::Result::Territory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Territory

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Territories>

=cut

__PACKAGE__->table("Territories");

=head1 ACCESSORS

=head2 territoryid

  data_type: 'text'
  is_nullable: 0

=head2 territorydescription

  data_type: 'text'
  is_nullable: 0

=head2 regionid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "territoryid",
  { data_type => "text", is_nullable => 0 },
  "territorydescription",
  { data_type => "text", is_nullable => 0 },
  "regionid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</territoryid>

=back

=cut

__PACKAGE__->set_primary_key("territoryid");

=head1 RELATIONS

=head2 employee_territories

Type: has_many

Related object: L<MyApp::Schema::Result::EmployeeTerritory>

=cut

__PACKAGE__->has_many(
  "employee_territories",
  "MyApp::Schema::Result::EmployeeTerritory",
  { "foreign.territoryid" => "self.territoryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 regionid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Region>

=cut

__PACKAGE__->belongs_to(
  "regionid",
  "MyApp::Schema::Result::Region",
  { regionid => "regionid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 employeeids

Type: many_to_many

Composing rels: L</employee_territories> -> employeeid

=cut

__PACKAGE__->many_to_many("employeeids", "employee_territories", "employeeid");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oB7LN4IOFjCQtoelFLN2vw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
