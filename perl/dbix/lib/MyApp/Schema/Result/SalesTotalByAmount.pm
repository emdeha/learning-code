use utf8;
package MyApp::Schema::Result::SalesTotalByAmount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::SalesTotalByAmount

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Sales Totals by Amount">

=cut

__PACKAGE__->table(\"\"Sales Totals by Amount\"");

=head1 ACCESSORS

=head2 saleamount

  data_type: (empty string)
  is_nullable: 1

=head2 orderid

  data_type: 'integer'
  is_nullable: 1

=head2 companyname

  data_type: 'text'
  is_nullable: 1

=head2 shippeddate

  data_type: 'datetime'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "saleamount",
  { data_type => "", is_nullable => 1 },
  "orderid",
  { data_type => "integer", is_nullable => 1 },
  "companyname",
  { data_type => "text", is_nullable => 1 },
  "shippeddate",
  { data_type => "datetime", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YycoTGLDeOrB73lIXi5Xnw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
