use lib 't/lib';
use strict;
use warnings;
use Test::Roo;

with qw(SQLite Retrieve);

run_me('retrieve');

done_testing;
