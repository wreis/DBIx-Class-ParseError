use lib 't/lib';
use Try::Tiny;
use Test::Roo;

with qw(Storage::PostgreSQL Storage::Setup);

test 'syntax error' => sub {
    my $self = shift;
    ok( my $schema = $self->schema, 'got schema' );
    my $exception = try {
        $schema->resultset('Foo')->search( \'1 ERROR COMING UP' )->all;
    }
    catch {
        my $error_str = $_;
        my $error     = $self->test_parse_error(
            {
                desc        => 'Syntax errors also throw exceptions',
                type        => 'custom_syntax_error',
                table       => '',
                source_name => '',
                error_str   => $error_str,
            }
        );

        is_deeply( $error->columns, [],     'target column' );
        is_deeply( $error->column_data, {}, 'check column data' );
        $error;
    };
};
test 'uknown function' => sub {
    my $self = shift;
    ok( my $schema = $self->schema, 'got schema' );
    my $exception = try {
        $schema->resultset('Foo')->search( \'SELECT no_such_function()' )->all;
    }
    catch {
        my $error_str = $_;
        my $error     = $self->test_parse_error(
            {
                desc        => 'Unknown functions also throw exceptions',
                type        => 'custom_unknown_function',
                table       => '',
                source_name => '',
                error_str   => $error_str,
            }
        );

        is_deeply( $error->columns, [],     'target column' );
        is_deeply( $error->column_data, {}, 'check column data' );
        $error;
    };
};

run_me;

done_testing;
