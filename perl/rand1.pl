
# Generate numbers between 0 and 6.
my $ceil = 7;

my $i;

for $i (1 .. 100) {
    # print "Pass $i: ", sprintf("%d", rand($ceil)), "\n";
    print "Pass $i: ", int(rand($ceil)), "\n";
}
