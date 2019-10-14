package Create;

use strict;
use warnings;
use Test::Roo::Role;

with 'Setup';

test '->create' => sub {
    my $self = shift;
    ok(my $schema = $self->_schema, 'got schema');
    my $foo_rs = $schema->resultset('Foo');
    ok( $foo_rs->create({ name => 'Foo' }), 'created Foo' );
};

1;
