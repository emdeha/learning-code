use utf8;
package MyApp::Schema::Result::AlphabeticalListOfProducts;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::AlphabeticalListOfProducts

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Alphabetical list of products">

=cut

__PACKAGE__->table(\"\"Alphabetical list of products\"");

=head1 ACCESSORS

=head2 productid

  data_type: 'integer'
  is_nullable: 1

=head2 productname

  data_type: 'text'
  is_nullable: 1

=head2 supplierid

  data_type: 'integer'
  is_nullable: 1

=head2 categoryid

  data_type: 'integer'
  is_nullable: 1

=head2 quantityperunit

  data_type: 'text'
  is_nullable: 1

=head2 unitprice

  data_type: 'numeric'
  is_nullable: 1

=head2 unitsinstock

  data_type: 'integer'
  is_nullable: 1

=head2 unitsonorder

  data_type: 'integer'
  is_nullable: 1

=head2 reorderlevel

  data_type: 'integer'
  is_nullable: 1

=head2 discontinued

  data_type: 'text'
  is_nullable: 1

=head2 categoryname

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "productid",
  { data_type => "integer", is_nullable => 1 },
  "productname",
  { data_type => "text", is_nullable => 1 },
  "supplierid",
  { data_type => "integer", is_nullable => 1 },
  "categoryid",
  { data_type => "integer", is_nullable => 1 },
  "quantityperunit",
  { data_type => "text", is_nullable => 1 },
  "unitprice",
  { data_type => "numeric", is_nullable => 1 },
  "unitsinstock",
  { data_type => "integer", is_nullable => 1 },
  "unitsonorder",
  { data_type => "integer", is_nullable => 1 },
  "reorderlevel",
  { data_type => "integer", is_nullable => 1 },
  "discontinued",
  { data_type => "text", is_nullable => 1 },
  "categoryname",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Cv6VSbbeRN5/LmhmNimYRA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
