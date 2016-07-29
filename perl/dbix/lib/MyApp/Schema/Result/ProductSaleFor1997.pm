use utf8;
package MyApp::Schema::Result::ProductSaleFor1997;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::ProductSaleFor1997

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Product Sales for 1997">

=cut

__PACKAGE__->table(\"\"Product Sales for 1997\"");

=head1 ACCESSORS

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
  "categoryname",
  { data_type => "text", is_nullable => 1 },
  "productname",
  { data_type => "text", is_nullable => 1 },
  "productsales",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6/FSjVLrvwnsDw5T+qIg4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
