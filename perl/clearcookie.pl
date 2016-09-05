#!/usr/local/bin/perl

use CGI;

{
    my $cgi = new CGI;

    my $cookie  = $cgi->cookie(-name    => 'testCookie',
 			       -value   => 'junk',
 			       -expires => '-1d',
 			       -path    => '/',
 			       -domain  => '172.23.4.12');

    print $cgi->header(-content_type => 'text/html', 
                       -cookie       => $cookie);

    my $message = "The cookie has been cleared.\n";

    print $cgi->start_html($message), $cgi->h1($message), $cgi->end_html();
}

