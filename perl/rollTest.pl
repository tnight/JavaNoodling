#!/usr/local/bin/perl -w
#
# Program:  rollTest.pl
# Language: Perl (AIX Unix-like environment)
#
# This program tests using Logfile::Rotate to roll a log file.  The
# file is actively being written to by another script during the test
# to ensure that the rolling process works without data loss.
#
#===========================================================================
# Date       Programmer        Changes
# --------------------------------------------------------------------------
#
# 03/24/2000 Terry Nightingale Created
#
#===========================================================================

use strict;

use Logfile::Rotate::Smart;

# Start of main routine

{
    my $file = '/tmp/writeLoop.log';

#     my $log = new Logfile::Rotate::Smart( File   => $file,
# 					    Gzip   => 'no',
# 					    Signal => \&send_hup );

    my $log = new Logfile::Rotate::Smart( File   => $file,
                                          Signal => \&send_hup );

    $log->rotate();
}

# End of main routine

sub send_hup
{
    # Attempt to read the process ID to send the HUP to.
    chomp(my $pid = `cat /tmp/writeLoop.pid`);

    # Make sure we found a process ID.
    $pid or warn "Could not find PID.\n";

    # Attempt to send the signal to the process.
    ($pid && kill('HUP', $pid))
	or warn "Could not send HUP signal to PID $pid: $!\n";
}
