#!/usr/local/bin/perl -w
#
# Program:  writeLoop.pl
# Language: Perl (AIX Unix-like environment)
#
# This program tests writing continuously to a log file using
# CommonSubs::logMessage to test for concurrency issues such as race
# conditions.
#
#===========================================================================
# Date       Programmer        Changes
# --------------------------------------------------------------------------
#
# 03/24/2000 Terry Nightingale Created
#
#===========================================================================

use vars qw($refreshConfig);

use strict;

use CommonSubs;

# Start of main routine

{
    # Record our process ID.
    system("echo $$ > /tmp/writeLoop.pid");

    my $file = '/tmp/writeLoop.log';

    #
    # Open our log file and tell it to flush after every write.
    #

    my $errlogName = $file;

    my $errlogHandle = new FileHandle;

    $errlogHandle->open(">>$errlogName")
        or die("Cannot open error log $errlogName: $!\n");
    $errlogHandle->autoflush(1);

    # Tell CommonSubs where to write our errors.
    CommonSubs::setErrlogHandle($errlogHandle);

    # Tell CommonSubs what level of errors to log.
    my $logLevel = 5;
    CommonSubs::setErrlogLevel($logLevel);

    # Make sure the config-refresh flag is false.
    $refreshConfig = '';

    # Set up our SIGHUP handler so we know when to roll our log file.
    $SIG{HUP} = \&catch_hup;

    # Start our loop of writing and sleeping.  Set $sleepVal to zero
    # (0) to test writing as fast as possible, but be warned that
    # disks can fill up quickly.
    my $count = 1;
    my $sleepVal = 0;

    for (;;) {

	# Check our configuration refresh flag, and if set, refresh
	# our configuration data and clear the flag.
	if ($refreshConfig) {

	    CommonSubs::logMessage("*** Refresh Config flag set, "
		. "re-initializing application instance...\n", 2);

	    $errlogHandle->close()
		or die("Cannot close error log handle: $!\n");

	    $errlogHandle->open(">>$errlogName")
		or die("Cannot open error log $errlogName: $!\n");
	    $errlogHandle->autoflush(1);

	    CommonSubs::logMessage(
                "Application instance reinitialized.\n", 2);

	    # Clear the refresh flag now that we've refreshed.
	    $refreshConfig = '';
	}

	# Write our line of output
	CommonSubs::logMessage("This is writeLoop output line $count.\n");

	# Wait for a while
	sleep($sleepVal);

	# Increment our counter
	$count++;
    }
}

# End of main routine

#===========================================================================
# Routine: catch_hup
#
# Purpose: Catch the SIGHUP signal, which we treat as a command to
#          re-read our configuration file and refresh our RVTBL
#          configuration data.
#
# Inputs:  The signal name that was caught (should be SIGHUP)
# Outputs: n/a
#---------------------------------------------------------------------------
sub catch_hup
{
    # Set a flag so our configuration data will get refreshed.
    $refreshConfig = 1;
}

