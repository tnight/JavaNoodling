#!/usr/local/bin/perl -Tw

# Note the -T switch! This is always recommended for Perl servers.

use strict;               # Always a good choice.

require RPC::PlServer;
require MD5;

package MD5_Server;  # Clients need to request application
                     # "MD5_Server"

$MD5_Server::VERSION = '1.0'; # Clients will be refused, if they
                              # request version 1.1

@MD5_Server::ISA = qw(RPC::PlServer);

# Begin Main

{
    eval {

        # Server options below can be overwritten in the
        # config file or on the command line.

        my $server = MD5_Server->new({
            # 'configfile' => 'md5serv.conf',
            'facility'   => 'daemon', # Default
            'group'      => 'nobody',
            'localport'  => 4000,
            # 'logfile'    => 0,        # Use syslog
            'logfile'    => '/tmp/md5serv.log',
            'mode'       => 'fork',   # Recommended for Unix
            'pidfile'    => '/tmp/md5serv.pid',
            'user'       => 'nobody',

            'methods'    => {
                'MD5_Server' => {
                    'ClientObject' => 1,
                    'CallMethod' => 1,
                    'NewHandle' => 1,
                    'DestroyHandle' => 1,
                    },
                'MD5' => {
                    'new' => 1,
                    'add' => 1,
                    'hexdigest' => 1,
                    },
                }
            });

        $server->Bind();
    };

}

# End Main

