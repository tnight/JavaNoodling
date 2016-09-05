#!/usr/bin/perl -w

# Initialize the logger

use Log::Log4perl qw(:levels);
use Log::Dispatch::Screen;
use Log::Log4perl::Appender;

my $app = Log::Log4perl::Appender->new("Log::Dispatch::Screen");
my $layout = Log::Log4perl::Layout::PatternLayout->new(
    "%d %-5p %c - %m%n");
$app->layout($layout);

my $logger = Log::Log4perl->get_logger("log.pl");
$logger->level($INFO);
$logger->add_appender($app);

# And after this, we can, again, start logging anywhere in
# the system like this (remember, we don't want to pass
# around references, so we just get the logger via the sin?
# gleton-mechanism):

# Use the logger

use Log::Log4perl;
my $log = Log::Log4perl->get_logger("log.pl");
$log->debug("Debug Message");  # Suppressed
$log->info("Info Message");    # Printed
$log->error("Error Message");  # Printed

