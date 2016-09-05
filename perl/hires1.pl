#!/usr/local/bin/perl
#
# Program:  hires1.pl
# Language: Perl (Microsoft Windows environment)
#
# This program is a test of using the Time::HiRes Perl extension to obtain
# the time of day down to the millisecond instead of just the second.
#
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 12/28/99   Terry Nightingale Created
#
#==============================================================================

use strict;
use Time::HiRes qw(time);

# Print the current time formatted as a localtime() style string.
my $time      = time();
my $localtime = localtime(int($time));
my $fraction  = substr($time - int($time), 2);

$localtime =~ s/(\d+:\d+:\d+)/$1.$fraction/;

print "Floating localtime = [$localtime]\n";

