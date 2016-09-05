#!/usr/bin/perl -w

# Initialize the logger

use Log::Dispatch::Screen;
use Log::Log4perl qw(:levels);
use Log::Log4perl::Appender;

sub main();
sub logSetup();
sub logUse();

main();

sub main() {
    logSetup();
    logUse();
}

sub logSetup() {

    my $app = Log::Log4perl::Appender->new("Log::Dispatch::Screen");
    my $layout = Log::Log4perl::Layout::PatternLayout->new(
        "%d %-5p %c - %m%n");
    $app->layout($layout);
    
    my $logger = Log::Log4perl->get_logger("log2.pl");
    $logger->level($INFO);
    $logger->add_appender($app);
}

sub logUse() {
    my $log = Log::Log4perl->get_logger("log2.pl");
    $log->debug("Debug Message");  # Suppressed
    $log->info("Info Message");    # Printed
    $log->error("Error Message");  # Printed
}

# End of script
