requires 'DBIx::Class';
requires 'Moo';

on test => sub {
    requires 'Test::Most';
    requires 'Test::Roo';
    requires 'Test::Requires';
    requires 'DBD::SQLite';
    requires 'SQL::Translator' => '0.11018';
};

on develop => sub {
    requires 'Test::Pod';
    requires 'Test::mysqld';
    requires 'DBD::mysql';
};
