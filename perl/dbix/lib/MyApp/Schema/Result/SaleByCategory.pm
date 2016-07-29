use utf8;
package MyApp::Schema::Result::SaleByCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::SaleByCategory

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Sales by Category">

=cut

__PACKAGE__->table(\"\"Sales by Category\"");

=head1 ACCESSORS

=head2 categoryid

  data_type: 'integer'
  is_nullable: 1

=head2 categoryname

  data_type: 'text'
  is_nullable: 1

=head2 productname

  data_type: 'text'
  is_nullable: 1

=head2 productsales

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "categoryid",
  { data_type => "integer", is_nullable => 1 },
  "categoryname",
  { data_type => "text", is_nullable => 1 },
  "productname",
  { data_type => "text", is_nullable => 1 },
  "productsales",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dCaGxAikakQj9clovqdwrQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
