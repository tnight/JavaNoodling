#!/usr/local/bin/perl -w

use strict;               # Always a good choice.

require RPC::PlClient;

# Constants
my $MY_APPLICATION = "MD5_Server";
my $MY_VERSION     = 1.0;
my $MY_USER        = "";                # The server doesn't require user
my $MY_PASSWORD    = "";                # authentication.

my $hexdigest = eval {
    my $client =
        RPC::PlClient->new(
            'peeraddr'    => '172.23.4.12',
            'peerport'    => 4000,
            'application' => $MY_APPLICATION,
            'version'     => $MY_VERSION,
            'user'        => $MY_USER,
            'password'    => $MY_PASSWORD
        );

    # Create an MD5 object on the server and an associated
    # client object. Executes a
    #     $context = MD5->new()
    # on the server.
    my $context = $client->ClientObject('MD5', 'new');

    # Let the server calculate a digest for us. Executes a
    #     $context->add("This is a silly string!");
    #     $context->hexdigest();
    # on the server.
    $context->add("This is a silly string!");
    $context->hexdigest();
};
if ($@) {
    die "An error occurred: $@";
}

print "Got digest $hexdigest\n";

