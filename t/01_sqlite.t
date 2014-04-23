use strict;
use warnings;
use Test::More;
use Otogiri;
use Otogiri::Plugin;

my $inflate_called = 0;

subtest 'can', sub {
    my ($db) = prepare();
    ok( $db->can('enable_inflate') );
    ok( $db->can('disable_inflate') );
};

subtest 'default (enable)', sub {
    my ($db, $id) = prepare();

    my $row = $db->single('person', { id => $id });
    is( $row->{name}, 'Sherlock Shellingford' );
    is( $row->{age},   15);
    is( $inflate_called, 1);
};


subtest 'enable_inflate', sub {
    my ($db, $id) = prepare();

    $db->enable_inflate;
    my $row = $db->single('person', { id => $id });
    is( $row->{name}, 'Sherlock Shellingford' );
    is( $row->{age},   15);
    is( $inflate_called, 1);
};

subtest 'disable_inflate', sub {
    my ($db, $id) = prepare();

    $db->disable_inflate;
    my $row = $db->single('person', { id => $id });
    is( $row->{name}, 'Sherlock Shellingford' );
    is( $row->{age},   15);
    is( $inflate_called, 0);
};

subtest 'enable_inflate with guard previous disabled', sub {
    my ($db, $id) = prepare();

    $db->disable_inflate;
    {
        my $guard = $db->enable_inflate;
        my $row = $db->single('person', { id => $id });
        is( $row->{name}, 'Sherlock Shellingford' );
        is( $row->{age},   15);
        is( $inflate_called, 1);
    }
    my $row = $db->single('person', { id => $id });
    is( $inflate_called, 1); #inflate is now disabled
};

subtest 'enable_inflate with guard previous enabled', sub {
    my ($db, $id) = prepare();

    $db->enable_inflate;
    {
        my $guard = $db->enable_inflate;
        my $row = $db->single('person', { id => $id });
        is( $row->{name}, 'Sherlock Shellingford' );
        is( $row->{age},   15);
        is( $inflate_called, 1);
    }
    my $row = $db->single('person', { id => $id });
    is( $inflate_called, 2);
};

subtest 'disable_inflate with guard previous disabled', sub {
    my ($db, $id) = prepare();

    $db->disable_inflate;
    {
        my $guard = $db->disable_inflate;
        my $row = $db->single('person', { id => $id });
        is( $row->{name}, 'Sherlock Shellingford' );
        is( $row->{age},   15);
        is( $inflate_called, 0);
    }
    my $row = $db->single('person', { id => $id });
    is( $inflate_called, 0);
};

subtest 'disable_inflate with guard previous enabled', sub {
    my ($db, $id) = prepare();

    $db->enable_inflate;
    {
        my $guard = $db->disable_inflate;
        my $row = $db->single('person', { id => $id });
        is( $row->{name}, 'Sherlock Shellingford' );
        is( $row->{age},   15);
        is( $inflate_called, 0);
    }
    my $row = $db->single('person', { id => $id });
    is( $inflate_called, 1);
};



done_testing;

sub prepare {
    $inflate_called = 0;
    my $db = Otogiri->new( 
        connect_info => ["dbi:SQLite:dbname=:memory:", '', '', { RaiseError => 1, PrintError => 0 }],
        inflate      => sub {
            my ($data, $table_name) = @_;
            $inflate_called++;
            return $data;
        },
    );
    $db->load_plugin('InflateSwitcher');
    my @sql_statements = split /\n\n/, <<EOSQL;
CREATE TABLE person (
  id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT    NOT NULL,
  age  INTEGER NOT NULL DEFAULT 20
);
EOSQL
    $db->do($_) for @sql_statements;

    $db->fast_insert('person', {
        name => 'Sherlock Shellingford',
        age  => 15,
    });

    my $id = $db->last_insert_id();
    return ($db, $id);
}
