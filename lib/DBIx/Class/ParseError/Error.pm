package DBIx::Class::ParseError::Error;

use strict;
use warnings;
use Moo;

use overload
    '""' => sub { shift->message },
    fallback => 1;

extends 'DBIx::Class::Exception';

has message => (is => 'ro', required => 1);

has [qw(type operation table source_name column_data columns)] => ( is => 'ro' );

1;

__END__

=pod

=head1 NAME

DBIx::Class::ParseError::Parser::Error - Structured error info

=head1 DESCRIPTION

=head1 AUTHOR

wreis - Wallace reis <wreis@cpan.org>

=head1 COPYRIGHT

Copyright (c) the L</AUTHOR> and L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
