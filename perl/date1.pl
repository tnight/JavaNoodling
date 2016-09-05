#!/usr/local/bin/perl -w

use Date::Calc;

{
    my (@beginYmd, @endYmd);

    @beginYmd = qw(2000 1 1);

    # Set ending date to beginning date plus $count months,
    # minus one day.  For example, a beginning date of 01/01/1999
    # with month count of 4 yields ending date of 04/30/1999.
    @endYmd = Date::Calc::Add_Delta_YMD(@beginYmd, 0, 4, 0);
    @endYmd = Date::Calc::Add_Delta_YMD(@endYmd, 0, 0, -1);

    print "After calc, \@endYmd = [@endYmd]\n";
}

