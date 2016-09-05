#!/usr/local/bin/perl -w
#
# Program:  mailTest.pl
# Language: Perl (AIX Unix-like environment)
#
# This program tests sending email via Net::SMTP.
#
#===========================================================================
# Date       Programmer        Changes
# --------------------------------------------------------------------------
#
# 03/02/2000 Terry Nightingale Created (branched from mailTest.pl)
#
#===========================================================================

use strict;

use lib '/home/terryn/proj/perl5lib';

# Include email subroutines.
use MailSubs;

# Include OO File Handle conveniences.
use FileHandle;

# Start of main routine

{
    my $rcptFile = 'mailTestTo.txt';

    my $body = <<END;
This is a test message.  Feel free to treat it as such by deleting it 
at will.  This message is being sent by Terry's mailTest3.pl program 
to test the use of the Net::SMTP module.  This message is sent in the 
hope that it will be useful, but with no warranty, including the 
implied warranties of merchantability and fitness for a particular 
purpose.  Use at your own risk.
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

    my $server = '12.18.177.81';

    my $email = {
        'body'         => $body,
        'content-type' => 'text/plain',
        'from'         => 'Evil Spammer <spam@foobar.com>',
        'subject'      => $subject,
        'to'           => $to
    };

    MailSubs::sendMail($server, $email);
}

# End of main routine

