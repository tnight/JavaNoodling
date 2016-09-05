#!c:/perl/bin/perl.exe -w

use Win32::Process;
use Win32;

sub ErrorReport
{
    print Win32::FormatMessage( Win32::GetLastError() );
}

# Start Main Routine

{
    my $proc;

    my $startingPort  = 8001;
    my $instanceCount = 50;

    my $endingPort    = $startingPort + $instanceCount - 1;

    print "Starting...\n";

    my $i;
    for $i ($startingPort .. $endingPort) {
        Win32::Process::Create(
			       $proc,
			       "D:\\perl\\bin\\perl.exe",
			       "perl qwproxy.pl >NUL",
			       0,
			       NORMAL_PRIORITY_CLASS,
			       "D:\\qwproxy")
            or die ErrorReport();
        print "Started $i...\n";
    }

    print "Done!\n";
}

# End Main Routine
