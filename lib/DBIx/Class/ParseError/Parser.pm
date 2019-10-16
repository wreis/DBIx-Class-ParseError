package DBIx::Class::ParseError::Parser;

use strict;
use warnings;
use Moo::Role;
use DBIx::Class::ParseError::Error;
use Regexp::Common qw(list);

requires 'type_regex';

has _schema => (
    is => 'ro', required => 1, init_arg => 'schema',
);

sub parse_type {
    my ($self, $error) = @_;
    my $type_regex = $self->type_regex;
    foreach (sort keys %$type_regex) {
        if ( $error =~ $type_regex->{$_} ) {
            return $_;
        }
    }
    return 'unknown';
}

sub _build_column_data {
    my ($self, $column_keys, $column_values) = @_;
    $column_keys = [split(/\,\s+/, $column_keys)];
    if ($column_values) {
        $column_values =~ s{\'}{}g;
        $column_values = [
            map { (split(/=/))[1] }
                split(/\,\s+/, $column_values)
        ];
        return {
            map {
                my $value = shift(@$column_values);
                $_ => ($value =~ m/undef/ ? undef : $value)
            } @$column_keys
        };
    }
    else {
        return { map { $_ => undef } @$column_keys };
    }
}

sub parse_general_info {
    my ($self, $error) = @_;

    my $insert_re = qr{
        INSERT\s+INTO\s+
        (\w+)\s+
        \( \s* ($RE{list}{-pat => '\w+'}|\w+)\s* \)\s+
        VALUES\s+
        \( \s* (?:$RE{list}{-pat => '\?'}|\?)\s* \)\s*\"
        \s*\w*\s*\w*:?\s*
        ($RE{list}{-pat => '\d=\'?[\w\s]+\'?'})?
    }ix;

    my $update_re = qr{
        UPDATE\s+
        (\w+)\s+
    }ix;

    my $missing_column_re = qr{
        (store_column|get_column)\(\)\:\s+
        no\s+such\s+column\s+['"](\w+)['"]\s+
        on\s+(?:TODOsource)?
    }ix;

    if ( $error =~ $insert_re ) {
        my ($table, $column_keys, $column_values) = ($1, $2, $3);
        return {
            operation => 'insert',
            table => $table,
            column_data => $self->_build_column_data(
                $column_keys, $column_values
            ),
        };
    }
    elsif ( $error =~ $update_re ) {
        my ($table) = ($1);
        return {
            operation => 'update',
            table => $table,
        };
    }
    elsif ( $error =~ $missing_column_re ) {
        my ($op_key, $column) = ($1, $2);
        my $op_mapping = {
            'store_column' => 'insert',
            'get_column' => 'update',
        };
        return {
            operation => $op_mapping->{ lc $op_key },
        };
    }
    else {
        die 'Parsing error string failed';
    }
}

sub process {
    my ($self, $error) = @_;
    my $err_info = {
        %{ $self->parse_general_info($error) },
        type => $self->parse_type($error),
    };
    $error = DBIx::Class::ParseError::Error->new(
        message => "$error",
        %$err_info,
    );
    return $error;
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::ParseError::Parser - Parser base class

=head1 DESCRIPTION

=head1 AUTHOR

wreis - Wallace reis <wreis@cpan.org>

=head1 COPYRIGHT

Copyright (c) the L</AUTHOR> and L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
