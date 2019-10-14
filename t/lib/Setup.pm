package Setup;

use strict;
use warnings;
use Test::Roo::Role;
use MySchema;

requires 'connect_info';

has _schema => (
    is => 'lazy',
);

sub _build__schema { MySchema->connect( shift->connect_info ) }

before setup => sub { shift->_schema->deploy };

1;
