#!/usr/local/bin/perl -w
#
# Program:  childTest.pl
# Language: Perl (Unix-like environment)
#
# This program tests Perl's ability to gather the exit code of a child
# process.
#
#===========================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 01/30/2002 Terry Nightingale Created
#
#===========================================================================

use strict;

$|++;

FORK: {
    if (my $pid = fork()) {
        # parent here
        # child process pid is available in $pid
        print "Now in parent, my pid is [$$]\n";
        print "Waiting...\n";
        my $foo = wait();
        my $rc = $? >> 8;
        print "After wait(), \$foo = [$foo], \$? = [$?], \$rc = [$rc]\n";
    }
    elsif (defined $pid) {
        # child here
        # parent process pid is available with getppid
        print "Now in child, my pid is [$$]\n";
        print "Sleeping...\n";
        sleep(10);
        print "Back from sleep, exiting...\n";
        exit(9);
    }
    elsif ($! =~ /No more process/) {
        # EAGAIN, supposedly recoverable fork error
        sleep 5;
        redo FORK;
    }
    else {
        # weird fork error
        die "Can't fork: $!\n";
    }
}

