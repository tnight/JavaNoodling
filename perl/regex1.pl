#!/usr/local/bin/perl -w

{
    my $pattern = '^wmfd(\d+)$';
    my $testString = 'wmfd5678';

    my $didMatch = ($testString =~ m/$pattern/);
    my $digits = $1;

    if ($didMatch) {
	print "It matched!  \$digits = [$digits]\n";
    }
    else {
	print "It didn't match!\n";
    }
}

