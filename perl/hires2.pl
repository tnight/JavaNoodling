#!/usr/local/bin/perl
#
# Program:  hires1.pl
# Language: Perl (Microsoft Windows environment)
#
# This program is a test of using the Time::HiRes Perl extension to obtain
# an interval of time down to the millisecond instead of just the second.
#
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 01/20/00   Terry Nightingale Created
#
#==============================================================================

use strict;
use Time::HiRes qw(gettimeofday sleep time tv_interval);

# Print the current time formatted as a localtime() style string.
my $tod       = [gettimeofday()];

sleep(1.52);

my $i;
for ($i = 0; $i < 2000; $i++) { ; }

my $interval  = tv_interval($tod);
my $time      = time;

print "Floating interval = [$interval], Floating time = [$time]\n";

