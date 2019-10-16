package Op::Update;

use strict;
use warnings;
use Test::Roo::Role;
use Try::Tiny;

with 'Storage::Setup';

has [qw(_foo _bar)] => ( is => 'rw' );

after setup => sub {
    my $self = shift;
    ok(my $schema = $self->schema, 'got schema');
    ok($self->_bar( $schema->resultset('Bar')->create({}) ), 'created Bar');
    ok( $self->_foo( $schema->resultset('Foo')->create({
        name => 'Foo',
        is_foo => 1,
        bar => $self->_bar,
    }) ), 'created Foo' );
};

test 'row->update' => sub {
    my $self = shift;
    my $row = $self->_foo;
    my $new_name = 'Bar';
    ok( $row->update({ name => $new_name }), 'updated Foo' );
    is($row->name, $new_name, 'updated to Bar');
};

my $time = time();

test 'foreign key' => sub {
    my $self = shift;
    ok(my $foo = $self->_foo, 'got Foo');
    try {
        $foo->update({ bar_id => 1000 })
    } catch {
        my $error = $_;
        ok($error, 'Failed to update with invalid FK');
    };
};

test 'not null' => sub {
    my $self = shift;
    ok(my $foo = $self->_foo, 'got Foo');
    try {
        $foo->update({ name => undef })
    } catch {
        my $error = $_;
        ok($error, 'Failed to update with NULL on not null');
        $foo->discard_changes;
    };
};

test 'data type' => sub {
    my $self = shift;
    ok(my $foo = $self->_foo, 'got Foo');
    try {
        $foo->update({ is_foo => 'text value' })
    } catch {
        my $error = $_;
        ok($error, 'Failed to update with invalid data type');
    };
};

test 'missing column' => sub {
    my $self = shift;
    ok(my $foo = $self->_foo, 'got Foo');
    try {
        $foo->update({ baz => 1000 })
    } catch {
        my $error = $_;
        ok($error, 'Failed to update with missing column');
    };
};

1;
