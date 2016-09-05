#!/cygdrive/d/Perl/bin/perl -w

use FileHandle;

my $g = $ARGV[0] || '/etc/group';

my $f = new FileHandle($g);
die "Open failed: $!" if not defined $f;

while (<$f>) {
    last if m/^qw_dual:/;
}

chomp;
my $users = (split(/:/))[3];
my @userList = split(',', $users);
#print "\@userList count = [", scalar @userList, "]\n";
my @newUserList = grep(!m/dual_\d+/, @userList);
#print "\@newUserList count = [", scalar @newUserList, "]\n";
print join("\n", @newUserList), "\n";

