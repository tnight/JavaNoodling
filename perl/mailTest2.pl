#!/usr/local/bin/perl
#
# Program:  mailTest2.pl
# Language: Perl (AIX Unix-like environment)
#
# This program tests sending email via Net::SMTP.
#
#===========================================================================
# Date       Programmer        Changes
# --------------------------------------------------------------------------
#
# 05/07/2001 Terry Nightingale Created (branched from mailTest.pl)
#
# 99/99/9999 ...               ...
#
#===========================================================================

use strict;

# Include OO File Handle conveniences.
use FileHandle;

# Include STMP email client module.
use Net::SMTP;

# Start of main routine

{
    my $rcptFile = 'mailTestTo.txt';

    my $body = <<END;
This is a test message -- feel free to treat it as such by deleting it
at will.  This message is being sent by Terry's mailTest2.pl program,
to test the use of the Net::SMTP module.
END

    my $subject = 'Net::SMTP Test Message';

    # Read our list of recipients from a text file.

    my $fh = new FileHandle($rcptFile)
        or die "Cannot open recipient file $rcptFile: $!\n";

    my @to = $fh->getlines();
    chomp(@to);

    # Close our filehandle since we no longer need it.
    $fh->close();

    my $smtp = Net::SMTP->new('12.18.177.81')
        or die "Can't create Net::SMTP object: $!";

    my $from = 'Foo "Mr. Baz Blech" Bar <foo@bar.com>';

    my $mailfrom = $from;
    if ($mailfrom =~ m/<(.*)>/) {
        $mailfrom = $1;
    }

    $smtp->mail($mailfrom);

    $smtp->to(@to) or die "Recipient error occurred.";

    $smtp->data();
    $smtp->datasend("From: $from\n");
    $smtp->datasend("To: " . join(',', @to) . "\n");
    $smtp->datasend("Subject: $subject\n");
    $smtp->datasend("\n");
    $smtp->datasend("$body\n");
    $smtp->dataend();

    $smtp->quit();
}

# End of main routine

