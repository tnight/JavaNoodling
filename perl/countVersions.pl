#!/usr/local/bin/perl -w

use strict;

use Getopt::Long;

my $usage = <<END;
countVersions.pl {-p|--pattern} <pattern> [file ...]
END

my %cmdOptions;
GetOptions(\%cmdOptions, qw(-p=s --pattern=s));
my $pattern = $cmdOptions{'p'} || $cmdOptions{'pattern'};
die $usage if not $pattern;

my %counts = ();
my (@list, $version);

while (<>) {
    m/$pattern/io;
    $version = $1 || 'unspecified';
    @list = split(/\s+/);
    $counts{$version} += $list[0] ? $list[0] : $list[1];
}

foreach $version (sort keys %counts) {
    print "$version: $counts{$version}\n";
}
