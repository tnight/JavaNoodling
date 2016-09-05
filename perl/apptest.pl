#!/usr/local/bin/perl -w
#
# Program:  apptest.pl
# Language: Perl (Windows/UNIX environment)
#
# This program is a test of the App.pm generic application module.
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 04/20/2000 Terry Nightingale Created
#
#==============================================================================

use strict;
use lib "/home/terryn/proj/perl5lib";

use TestApp;

# Start of main routine

{
    print "Made it to main routine.\n";
    print "Instantiating a TestApp object...\n";
    my $app = TestApp->new('TestApp.ini');
    print "Made it past instantiation.\n";

    while (! -f '/tmp/apptest.stop') {
      print "Sleeping so signals can be sent...\n";
      sleep(60);
      print "Reached end of while loop.\n";
    }

    print "Done processing, shutting down.\n";
}

# End of main routine
