use lib 't/lib';
use strict;
use warnings;
use Test::Roo;

with qw(Storage::PostgreSQL Op::Create);

run_me('missing table');

done_testing;
