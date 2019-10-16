use lib 't/lib';
use strict;
use warnings;
use Test::Roo;

with qw(Storage::MySQL MissingTable);

run_me('missing table');

done_testing;
