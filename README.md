# NAME

DBIx::Class::ParseError - Extensible database error handler

# SYNOPSIS

From:

    DBIx::Class::Storage::DBI::_dbh_execute(): DBI Exception: DBD::mysql::st execute failed: Duplicate entry \'1\' for key \'PRIMARY\' [for Statement "INSERT INTO foo ( bar_id, id, is_foo, name) VALUES ( ?, ?, ?, ? )" with ParamValues: 0=1, 1=1, 2=1, 3=\'Foo1571434801\'] at ...

To:

    bless({
        'table' => 'foo',
        'columns' => [
            'id'
        ],
        'message' => 'DBIx::Class::Storage::DBI::_dbh_execute(): DBI Exception: DBD::mysql::st execute failed: Duplicate entry \'1\' for key \'PRIMARY\' [for Statement "INSERT INTO foo ( bar_id, id, is_foo, name) VALUES ( ?, ?, ?, ? )" with ParamValues: 0=1, 1=1, 2=1, 3=\'Foo1571434801\'] at ...',
        'operation' => 'insert',
        'column_data' => {
            'name' => 'Foo1571434801',
            'bar_id' => '1',
            'id' => '1',
            'is_foo' => '1'
        },
        'source_name' => 'Foo',
        'type' => 'primary_key'
    }, 'DBIx::Class::ParseError::Error' );

# DESCRIPTION

# AUTHOR

wreis - Wallace reis <wreis@cpan.org>

# COPYRIGHT

Copyright (c) the ["AUTHOR"](#author) and ["CONTRIBUTORS"](#contributors) as listed above.

# LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

# SPONSORSHIP

This module exists due to the wonderful people at IntelliTree Solutions [http://www.intellitree.com](http://www.intellitree.com).
