
use strict;

use MLDBM qw(DB_File Storable);

use Fcntl;

my %o;
tie %o, 'MLDBM', '/tmp/testmldbm', O_CREAT|O_RDWR, 0640 or die $!;

(tied %o)->DumpMeth('portable');
$o{'ENV'} = \%ENV;

