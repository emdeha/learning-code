use utf8;
package MyApp::Schema::Result::CustomerAndSupplierByCity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::CustomerAndSupplierByCity

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Customer and Suppliers by City">

=cut

__PACKAGE__->table(\"\"Customer and Suppliers by City\"");

=head1 ACCESSORS

=head2 city

  data_type: 'text'
  is_nullable: 1

=head2 companyname

  data_type: 'text'
  is_nullable: 1

=head2 contactname

  data_type: 'text'
  is_nullable: 1

=head2 relationship

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "city",
  { data_type => "text", is_nullable => 1 },
  "companyname",
  { data_type => "text", is_nullable => 1 },
  "contactname",
  { data_type => "text", is_nullable => 1 },
  "relationship",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:enblldzefvSWX/xswgl7mw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
