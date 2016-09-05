#!/usr/local/bin/perl -Tw
#
# Program:  getuid.pl
# Language: Perl (UNIX environment)
#
# This program is a test to see whether setuid/setgid Perl programs
# work properly, i.e. that the effective user and group id's actually
# change when the permissions indicate that they should.
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 01/08/2001 Terry Nightingale Created
#
#==============================================================================

use strict;
use English;

# Begin main routine.

{
    print "uid = [$UID], gid = [$GID]\n";
    print "euid = [$EUID], egid = [$EGID]\n";

    $ENV{'PATH'} = '/bin';
    system("touch getuid.perl.file");
}

# End main routine.
