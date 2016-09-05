#!/usr/local/bin/perl
#
# Program:  hires3.pl
# Language: Perl (Microsoft Windows environment)
#
# This program is a test of using the Time::HiRes Perl extension to format
# and print a date/time stamp with fractional seconds.
#
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 01/21/00   Terry Nightingale Created
#
#==============================================================================

use strict;
use Time::HiRes qw(gettimeofday);

for ( 1 .. 10 ) {

    # Get the current time formatted as a localtime() style string.
    my $tod = [gettimeofday()];
    my @lt  = localtime($tod->[0]);

    $lt[4] += 1;
    $lt[5] += 1900;

    my $timestamp = sprintf("%4d-%02d-%02d %02d:%02d:%02d.%03d",
        $lt[5], $lt[4], $lt[3], $lt[2], $lt[1], $lt[0],
        substr($tod->[1], 0, -3));

    print "Formatted date/time stamp = [$timestamp]\n";

    ### select(undef, undef, undef, rand());
}
