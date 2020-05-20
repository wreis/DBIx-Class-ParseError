use lib 't/lib';
use Test::Roo;

with qw(Storage::PostgreSQL Op::Update);

run_me('update');

sub _override_test_behavior {
    data_type => {
        columns => {
            skip =>
'PostgreSQL error message does not provide a clean way of fetching this data'
        }
    };
}

sub should_skip {
    my ( $self, $data_type, $feature ) = @_;
    return $self->_override_test_behavior->{$data_type}{$feature}{skip};
}

done_testing;
