package DBIx::Class::ParseError;

use strict;
use warnings;
use Moo;
use Try::Tiny;
use Module::Runtime 'use_module';
use DBIx::Class::Exception;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

has _schema => (
    is => 'ro', required => 1, init_arg => 'schema',
    handles => { _storage => 'storage' }
);

has db_driver => (
    is => 'lazy', init_arg => undef,
);

sub _build_db_driver { shift->_storage->sqlt_type }

has _parser_class => (
    is => 'lazy', builder => '_build_parser_class',
);

sub _build_parser_class {
    return join q{::}, 'DBIx::Class::ParseError::Parser', shift->db_driver;
}

has _parser => (
    is => 'lazy', builder => '_build_parser',
);

sub _build_parser {
    my $self = shift;
    return try {
        use_module($self->_parser_class)->new(
            schema => $self->_schema
        )
    } catch { die 'No parser found for ' . $self->_db_driver };
}

sub process {
    my ($self, $error) = @_;
    return try { $self->_parser->process($error) }
        catch { warn $_; DBIx::Class::Exception->throw($error) };
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::ParseError - Extensible database error handler

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

wreis - Wallace reis <wreis@cpan.org>

=head1 COPYRIGHT

Copyright (c) the L</AUTHOR> and L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=head1 SPONSORSHIP

This module exists due to the wonderful people at IntelliTree Solutions L<http://www.intellitree.com>.

=cut
