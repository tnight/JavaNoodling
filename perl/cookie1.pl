#!/usr/local/bin/perl -w

use CGI;

{
    my $cgi = new CGI;

    my $cookie = $cgi->cookie(-name=>'sessionID',
                              -path=>'/foo/bar/baz',
                              -value=>'foobar');

    print "\$cookie = [$cookie]\n";
}

