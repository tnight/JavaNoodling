#!/usr/local/bin/perl

my ($key, $value);

print "Content-Type: text/html\n\n";

print "<html><head><title>Test</title></head><body bgcolor='ffffff'><pre>\n";

print "Environment Dump:\n\n";

foreach $key (sort(keys(%ENV))) {
    print "[$key] = [$ENV{$key}]\n"
}

print "\n\n";

print "CGI variable dump:\n\n";

use CGI;

my $query = new CGI;

foreach $key (sort($query->param())) {
    $value = $query->param($key);
    print "[$key] = [$value]\n";
}

print "Cookie Dump:\n\n";

foreach $key (split(/; /, $query->raw_cookie())) {
    print "[$key]\n";
}

print "\n\n";

print "</pre></body></html>\n";
