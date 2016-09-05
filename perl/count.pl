#!/usr/local/bin/perl -w

use strict;

my $count = 0;
my @list;

while (<>) {
    @list = split(/\s+/);
    $count += $list[0] ? $list[0] : $list[1];
}

print $count, "\n";
