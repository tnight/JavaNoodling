#!/usr/local/bin/perl -w
#
# Program:  mailTest.pl
# Language: Perl (AIX Unix-like environment)
#
# This program tests sending email via sendmail.
#
#===========================================================================
# Date       Programmer        Changes
# --------------------------------------------------------------------------
#
# 03/02/2000 Terry Nightingale Created
#
# 10/19/2000 Terry Nightingale Eliminated 'use' of unused modules.
#
#===========================================================================

use strict;

### use lib '/home/terryn/proj/perl5lib';

# Include IronWorx common subroutines.
use CommonSubs;

# Include OO File Handle conveniences.
use FileHandle;

# Start of main routine

{
    my $rcptFile = '/home/terryn/src/mailTestTo.txt';

    my $body = <<END;
This is a test message.  Any other use, misuse, abuse, or
other appropriation is strictly prohibited.
END

    my $subject = 'Test Message';

    # Read our list of recipients from a text file.

    my $fh = new FileHandle($rcptFile)
        or die "Cannot open recipient file $rcptFile: $!\n";

    my @to = $fh->getlines();
    chomp(@to);

    # Close our filehandle since we no longer need it.
    $fh->close();

    my $to = join(',', @to);

    my $email = {
        'body'         => $body,
        'content-type' => 'text/plain',
        'from'         => 'Foo Bar <foo@bar.com>',
        'subject'      => $subject,
        'to'           => $to
    };

    CommonSubs::_sendMail($email);
}

# End of main routine

