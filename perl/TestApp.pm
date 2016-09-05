
package TestApp;

use strict;
use lib "/home/terryn/proj/perl5lib";
use vars qw(@ISA);

use App;

@ISA = qw(App);

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = $class->SUPER::new('TestApp', @_);
    bless($self, $class);
    return $self;
}

1;


