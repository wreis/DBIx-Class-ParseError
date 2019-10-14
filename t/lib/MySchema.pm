package MySchema::Foo;

use strict;
use warnings;
use Moo;

extends 'DBIx::Class::Core';

__PACKAGE__->table('foo');
__PACKAGE__->add_columns(
    id => {
        data_type => 'int',
        is_auto_increment => 1,
    },
    name => {
        data_type => 'varchar',
        size => 100,
    },
);
__PACKAGE__->set_primary_key('id');

package MySchema;

use strict;
use warnings;
use Moo;

extends 'DBIx::Class::Schema';

__PACKAGE__->register_class('Foo', 'MySchema::Foo');

1;
