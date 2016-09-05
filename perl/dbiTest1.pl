#!/usr/local/bin/perl -w

use strict;
use DBI;

{
    my $output;

    my (@drivers, @databases);

    @drivers = DBI->available_drivers();
    $output = join(', ', @drivers);
    print "Found the following drivers: [$output]\n";

    @databases = DBI->data_sources('mysql');
    $output = join(', ', @databases);
    print "Found the following mysql databases: [$output]\n";

    print "Trying alternate method...\n";

    my ($host, $port) = ('localhost', '');
    my $drh = DBI->install_driver('mysql');
    @databases = $drh->func($host, $port, '_ListDBs');
    $output = join(', ', @databases);
    print "Found the following mysql databases: [$output]\n";
}

