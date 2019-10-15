use lib 't/lib';
use strict;
use warnings;
use Test::Roo;

with qw(SQLite Update);

run_me('update');

done_testing;
