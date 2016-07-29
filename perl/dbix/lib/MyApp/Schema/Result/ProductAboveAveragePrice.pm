use utf8;
package MyApp::Schema::Result::ProductAboveAveragePrice;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::ProductAboveAveragePrice

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<"Products Above Average Price">

=cut

__PACKAGE__->table(\"\"Products Above Average Price\"");

=head1 ACCESSORS

=head2 productname

  data_type: 'text'
  is_nullable: 1

=head2 unitprice

  data_type: 'numeric'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "productname",
  { data_type => "text", is_nullable => 1 },
  "unitprice",
  { data_type => "numeric", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-29 08:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jBP47RHxDaMiuqkvQPMMbw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
