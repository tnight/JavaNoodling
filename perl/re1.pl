#!/usr/local/bin/perl -w

use strict;

# Test a substitution used in templates.

{
    my %params;

    $params{'name'} = 'Terry';
    $params{'choice'} = 'yes';

    my $buffer = <<EOB;
<input name="name" type="text" value="^^name^^">
<input name="choice" type="radio" value="yes" ^^choice:yes:CHECKED^^>
<input name="choice" type="radio" value="no" ^^choice:no:CHECKED^^>
EOB

    print "Before sub, \$buffer = \n$buffer\n";

    foreach my $key (keys %params) {
	my $val = $params{$key};
	$buffer =~ s!\Q^^$key^^\E!$val!gs;
	$buffer =~ s!\Q^^$key:$val:\E(\w+)\Q^^\E!$1!gs;
    }

    # Nuke any remaining tokens.
    $buffer =~ s!\Q^^\E.+?\Q^^\E!!go;

    print "After sub, \$buffer  = \n$buffer\n";
}
