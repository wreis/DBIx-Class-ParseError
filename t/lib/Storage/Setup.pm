package Storage::Setup;

use strict;
use warnings;
use Test::Roo::Role;
use MySchema;

requires 'connect_info';

has _schema => (
    is => 'lazy',
);

sub _build__schema { MySchema->connect( shift->connect_info ) }

has sources => (
    is => 'ro', predicate => 1,
);

before setup => sub {
    my $self = shift;
    $self->_schema->deploy({
        $self->has_sources ? ( sources => $self->sources ) : ()
    });
};

1;
