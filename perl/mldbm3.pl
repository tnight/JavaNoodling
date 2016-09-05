#!c:/perl/bin/perl.exe -w

use strict;

use MLDBM qw(DB_File Storable);
use Fcntl;

my %o;
my $dbm = tie %o, 'MLDBM', 'd:/temp/sessions.dbm',
    O_RDONLY, 0640 or die $!;

#
# to see what was stored
#
use Data::Dumper;
print Data::Dumper->Dump([\%o], [qw(o)]);

