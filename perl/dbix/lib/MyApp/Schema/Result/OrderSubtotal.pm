use utf8;
package MyApp::Schema::Result::OrderSubtotal;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::OrderSubtotal

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Order Subtotals">

=cut

__PACKAGE__->table(\"\"Order Subtotals\"");

=head1 ACCESSORS

=head2 orderid

  data_type: 'integer'
  is_nullable: 1

=head2 subtotal

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "orderid",
  { data_type => "integer", is_nullable => 1 },
  "subtotal",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l+cyzMKbAqtMXI89joEN+w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
