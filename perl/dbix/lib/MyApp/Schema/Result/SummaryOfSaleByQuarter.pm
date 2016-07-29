use utf8;
package MyApp::Schema::Result::SummaryOfSaleByQuarter;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::SummaryOfSaleByQuarter

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Summary of Sales by Quarter">

=cut

__PACKAGE__->table(\"\"Summary of Sales by Quarter\"");

=head1 ACCESSORS

=head2 shippeddate

  data_type: 'datetime'
  is_nullable: 1

=head2 orderid

  data_type: 'integer'
  is_nullable: 1

=head2 subtotal

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "shippeddate",
  { data_type => "datetime", is_nullable => 1 },
  "orderid",
  { data_type => "integer", is_nullable => 1 },
  "subtotal",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pKHuL4n0J7fBg2IE6Kx6gA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
