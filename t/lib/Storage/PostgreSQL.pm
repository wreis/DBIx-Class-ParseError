package Storage::PostgreSQL;

use Test::Roo::Role;
use Test::PostgreSQL;
with qw(Storage::Common);

BEGIN {
    unless ( $ENV{AUTHOR_TESTING} ) {
        plan skip_all => 'SKIP these tests are for testing by the author';
    }
    unless ( $ENV{POSTGRES_HOME} ) {
        plan skip_all =>
          "SKIP postgresql tests because POSTGRES_HOME env variable not set";
    }
}

use Test::Requires qw(DBD::Pg);

has _pg => ( is => 'lazy', );

sub _build__pg {
    return Test::PostgreSQL->new;
}

sub connect_info { shift->_pg->dsn }

1;
