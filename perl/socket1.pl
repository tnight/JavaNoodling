#!/usr/local/bin/perl -w
#
# Program:  socket1.pl
# Language: Perl (UNIX environment)
#
# This program is a test to see whether I can duplicate the
# functionality of the cgi-fcgi shunt program for starting FastCGI
# applications in Perl, thus making the shunt unnecessary.
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 02/28/2000 Terry Nightingale Created
#
#==============================================================================

use strict;
use FileHandle;
use IO::Socket;

my $serverPort = 8051;

close(STDIN);
close(STDOUT);
close(STDERR);

my $sock = IO::Socket::INET->new(
    Listen    => 5,
    LocalPort => $serverPort,
    Proto     => 'tcp',
    Reuse     => 1,
    Type      => SOCK_STREAM
);

my $logFile = new FileHandle(">socket1.out");
$logFile->autoflush(1);
$logFile->print("Made it past instantiation.\n");
$logFile->print("File Number = [", fileno($sock), "]\n");
$logFile->print("Calling listen()...\n");

$sock->listen();

$logFile->print("Listening...\n");
$logFile->close();
while (1) {
    sleep(1);
}
