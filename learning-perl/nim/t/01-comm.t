#!/usr/bin/perl

use Test::More tests => 8;

BEGIN { use_ok('Test::Comm', ':comm'); }

my $comm = comm_init();

is_deeply $comm, { lines => {} },
          'comm_init() returned an empty comm objec';

is_deeply [ comm_encode_text($comm, 'bar', 'tag') ],
    [ 'tag bar' ];
is_deeply [ comm_encode_text($comm, '', 'foo') ],
    [ 'foo ' ];
is_deeply [ comm_encode_text($comm, 'bar\n\n\n', 'another') ],
    [ 'another bar' ];
is_deeply [ comm_encode_text($comm, 'foo\nbar', 'a') ],
    [ 'a-foo', 'a bar' ];
is_deeply [ comm_encode_text($comm, 'foo\n\nbar', 'a') ],
    [ 'a-foo', 'a-', 'a bar' ];
is_deeply [ comm_encode_text($comm, 'foo\n\nbar\n\n\n', 'a') ],
    [ 'a-foo', 'a-', 'a bar' ];

# is ref $comm, 'HASH', 'comm_init() returned a hasref';
# is join(' ', keys %{$comm}), 'lines', 'comm_init() only has single "lines" member';
# is ref $comm->{lines}, 'HASH', 'comm->lines is a hashref';
# is scalar keys %{$comm->{lines}}, 0, 'comm->lines is empty';
