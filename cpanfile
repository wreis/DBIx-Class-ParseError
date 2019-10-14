requires 'DBIx::Class';
requires 'Moo';

on test => sub {
    requires 'Test::Most';
    requires 'Test::Requires';
    requires 'DBD::SQLite';
};

on develop => sub {
    requires 'Test::Pod';
    requires 'Test::mysqld';
    requires 'DBD::mysql';
};
