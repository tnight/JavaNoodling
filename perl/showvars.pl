#! /usr/bin/perl -w
#===========================================================================
#
# Program: showvars.pl
#
# Copywright 2000  Ironworx LLC <http://www.ironworx.com>
#
# Purpose: Show the environment, CGI vars, and current directory.
#
# Created: 02/01/2000 by Terry Nightingale <tnight@ironworx.com>
#
# Changed: 99/99/9999 by ... to ...
#
#---------------------------------------------------------------------------

use strict;

# Necessary for DGC Server
use lib "/u/web/dgcweb/perl-lib";

use CGI;
use Cwd;

# Scalar to hold our text output.
my $output = '';

# Hash iterator variable.
my $key;

# Ascertain our current directory.
my $currentDir = getcwd();

# Append the current directory to the output.
$output .= "\nCurrent directory = [$currentDir]\n";

# Append the contents of the environment to the output.
$output .= "\nEnvironment Dump:\n\n";
foreach $key (sort keys %ENV) {
    $output .= "[$key] = [$ENV{$key}]\n";
} 

# Append any CGI parameters to the output.

my $cgi = new CGI;

$output .= "\nCGI Parameter Dump:\n\n";
 
foreach $key ($cgi->param()) {
    $output .= "[$key] = [" . $cgi->param($key) . "]\n";
} 

# Mark the end of the story.
$output .= "\nEnd of Output.\n";

# Show our output to the browser.
print $cgi->header('text/plain'), $output;

