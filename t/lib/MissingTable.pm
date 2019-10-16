package MissingTable;

use strict;
use warnings;
use Test::Roo::Role;
use Try::Tiny;
use Test::Exception;
use DBIx::Class::ParseError;

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
    my $exception = try {
        $schema->resultset('Foo')->create({
            name => 'Foo',
            is_foo => 1,
            bar => $bar,
        })
    } catch {
        my $error_str = $_;
        my $parser = DBIx::Class::ParseError->new(schema => $self->_schema);
        my $error = $parser->parse($error_str);
        is($error_str, $error, 'stringfy');
        isa_ok($error, 'DBIx::Class::Exception', '::ParseError::Error');
        is($error_str, $error->message, 'same error str in message');
        is($error->type, 'missing_table', 'error type');
        is($error->table, 'foo', 'target table');
        ok(!$error->column, 'no column involved');
        ok(!$error->value, 'no value');
        $error;
    };
    dies_ok { $exception->rethrow };
};

1;
