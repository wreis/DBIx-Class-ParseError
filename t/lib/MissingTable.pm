package MissingTable;

use strict;
use warnings;
use Test::Roo::Role;
use Try::Tiny;

with 'Storage::Setup';

around BUILDARGS => sub {
    my ($orig, $class, $args) = @_;
    $args = {
        %$args,
        sources => [qw(Bar)],
    };
    return $class->$orig($args);
};

test 'no table foo' => sub {
    my $self = shift;
    ok(my $schema = $self->_schema, 'got schema');
    ok(my $bar = $schema->resultset('Bar')->create({}), 'created Bar');
    try {
        $schema->resultset('Foo')->create({
            name => 'Foo',
            is_foo => 1,
            bar => $bar,
        })
    } catch {
        my $error = $_;
        like($error, qr/foo/, 'Missing table foo');
    };
};

1;
