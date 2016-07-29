use utf8;
package MyApp::Schema::Result::Employee;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Employee

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Employees>

=cut

__PACKAGE__->table("Employees");

=head1 ACCESSORS

=head2 employeeid

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 lastname

  data_type: 'text'
  is_nullable: 1

=head2 firstname

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 titleofcourtesy

  data_type: 'text'
  is_nullable: 1

=head2 birthdate

  data_type: 'date'
  is_nullable: 1

=head2 hiredate

  data_type: 'date'
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

=head2 homephone

  data_type: 'text'
  is_nullable: 1

=head2 extension

  data_type: 'text'
  is_nullable: 1

=head2 photo

  data_type: 'blob'
  is_nullable: 1

=head2 notes

  data_type: 'text'
  is_nullable: 1

=head2 reportsto

  data_type: 'integer'
  is_nullable: 1

=head2 photopath

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "employeeid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
  },
  "lastname",
  { data_type => "text", is_nullable => 1 },
  "firstname",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "titleofcourtesy",
  { data_type => "text", is_nullable => 1 },
  "birthdate",
  { data_type => "date", is_nullable => 1 },
  "hiredate",
  { data_type => "date", is_nullable => 1 },
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
  "homephone",
  { data_type => "text", is_nullable => 1 },
  "extension",
  { data_type => "text", is_nullable => 1 },
  "photo",
  { data_type => "blob", is_nullable => 1 },
  "notes",
  { data_type => "text", is_nullable => 1 },
  "reportsto",
  { data_type => "integer", is_nullable => 1 },
  "photopath",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</employeeid>

=back

=cut

__PACKAGE__->set_primary_key("employeeid");

=head1 RELATIONS

=head2 employee

Type: might_have

Related object: L<MyApp::Schema::Result::Employee>

=cut

__PACKAGE__->might_have(
  "employee",
  "MyApp::Schema::Result::Employee",
  { "foreign.employeeid" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 employee_territories

Type: has_many

Related object: L<MyApp::Schema::Result::EmployeeTerritory>

=cut

__PACKAGE__->has_many(
  "employee_territories",
  "MyApp::Schema::Result::EmployeeTerritory",
  { "foreign.employeeid" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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

=head2 orders

Type: has_many

Related object: L<MyApp::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "MyApp::Schema::Result::Order",
  { "foreign.employeeid" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 territoryids

Type: many_to_many

Composing rels: L</employee_territories> -> territoryid

=cut

__PACKAGE__->many_to_many("territoryids", "employee_territories", "territoryid");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/AxX3f66GD19hLvWeljOZA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
