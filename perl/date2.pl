#!/usr/local/bin/perl -w

use Date::Manip;
use Time::Local;

{
    my ($todayLong, $todaySecs) =
	Date::Manip::UnixDate('today at midnight', '%F', '%s');

    my @localtime = localtime();

    # Set the time to midnight.
    $localtime[0] = $localtime[1] = $localtime[2] = 0;

    # Get the number of seconds.
    my $todaySecs2 = timelocal(@localtime);

    my $output = join('|', $todayLong, $todaySecs, $todaySecs2);

    print "\$todayLong, \$todaySecs, \$todaySecs2 = \n[$output]\n";
}

