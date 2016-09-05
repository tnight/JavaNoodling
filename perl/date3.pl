#!/usr/local/bin/perl -w

use strict;
use Date::Manip;

{
    my ($date,$date2) = ('20001011', '');
    ($date, $date2) = &UnixDate(&ParseDate($date), '%A, %B %e, %Y', '%Y-%m-%d');

    print "\$date, \$date2 = [$date] [$date2]\n";
}

