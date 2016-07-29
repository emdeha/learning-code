use utf8;
package MyApp::Schema::Result::Category;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Category

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Categories>

=cut

__PACKAGE__->table("Categories");

=head1 ACCESSORS

=head2 categoryid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 categoryname

  data_type: 'text'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 picture

  data_type: 'blob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "categoryid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "categoryname",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "picture",
  { data_type => "blob", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</categoryid>

=back

=cut

__PACKAGE__->set_primary_key("categoryid");

=head1 RELATIONS

=head2 product

Type: might_have

Related object: L<MyApp::Schema::Result::Product>

=cut

__PACKAGE__->might_have(
  "product",
  "MyApp::Schema::Result::Product",
  { "foreign.productid" => "self.categoryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rV3v4gd769HZOUg6JXLnxA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
