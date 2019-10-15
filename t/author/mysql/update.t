use lib 't/lib';
use strict;
use warnings;
use Test::Roo;

BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    plan skip_all => 'SKIP these tests are for testing by the author';
  }
}

use Test::Requires qw(DBD::mysql Test::mysqld);

with qw(MySQL Update);

run_me('update');

done_testing;
