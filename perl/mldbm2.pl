
use strict;

use MLDBM qw(DB_File Storable);
use Fcntl;

my %o;
my $dbm = tie %o, 'MLDBM', 'testmldbm', O_CREAT|O_RDWR, 0640 or die $!;

my $c = [\ 'c'];
my $b = {};
my $a = [1, $b, $c];
$b->{a} = $a;
$b->{b} = $a->[1];
$b->{c} = $a->[2];
@o{qw(a b c)} = ($a, $b, $c);

#
# to see what was stored
#
use Data::Dumper;
print Data::Dumper->Dump([@o{qw(a b c)}], [qw(a b c)]);

#
# to modify data in a substructure
#
my $tmp = $o{a};
$tmp->[0] = 'foo';
$o{a} = $tmp;

#
# can access the underlying DBM methods transparently
#
print $dbm->fd, "\n";

