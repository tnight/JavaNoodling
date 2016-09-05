#!/usr/local/bin/perl -w
#
# Program:  initest.pl
# Language: Perl (UNIX environment)
#
# This program is a test to see whether IniConf's signal handling is
# working as advertised.
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 02/23/2000 Terry Nightingale Created
#
#==============================================================================

use strict;
use vars qw($oldhup);

use IniConf;

sub catch_hup
{
    print "Now in catch_hup()...\n";
    no strict 'refs';
    &$oldhup;
    use strict 'refs';
    $SIG{HUP} = \&catch_hup;
}

# Start of main routine

{
    my $sharedPrefix  = "/usr/local/share";
    my $iniFile       = "${sharedPrefix}/ini/allapps.ini";

    my $cfg = new IniConf(
	-default   => 'default',
        -file      => $iniFile,
        -reloadsig => 'SIGHUP')
    or die(
        "Cannot open initialization file $iniFile: @IniConf::errors\n");

    $oldhup = $SIG{HUP};
    $SIG{HUP} = \&catch_hup;

    eval {
	while (1) {
	    my $level = $cfg->val('rvbsr', 'errorLogLevel');
	    print "Error log level = [$level]\n";
	    sleep(5);
	}
    }
}

# End of main routine
