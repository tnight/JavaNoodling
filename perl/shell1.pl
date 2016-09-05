#!/usr/local/bin/perl -w
#
# Program:  shell1.pl
# Language: Perl (UNIX environment)
#
# This program is a test to see whether the Korn shell will honor my
# numeric argument when the next non-whitespace character after the
# number is a greater-than (>).
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 03/14/2000 Terry Nightingale Created
#
#==============================================================================

use strict;

for (my $i = 0; $i < @ARGV; $i++) {
    print "Argument [$i] = [$ARGV[$i]]\n";
}
