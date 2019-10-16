package DBIx::Class::ParseError::Parser::SQLite;

use strict;
use warnings;
use Moo;

with 'DBIx::Class::ParseError::Parser';

sub type_regex {
    return {
        data_type => qr{attrs_for_bind\(\)\:.+value\s+supplied\s+for\s+column}i,
        missing_table => qr{no\s+such\s+table}i,
        missing_column => qr{no\s+such\s+column}i,
        not_null => qr{NOT\s+NULL\s+constraint\s+failed}i,
        unique_key => qr{UNIQUE\s+constraint\s+failed}i,
    };
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::ParseError::Parser::SQLite - Parser for SQLite

=head1 DESCRIPTION

=head1 AUTHOR

wreis - Wallace reis <wreis@cpan.org>

=head1 COPYRIGHT

Copyright (c) the L</AUTHOR> and L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
