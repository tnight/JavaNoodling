#!/usr/local/bin/perl -w

package Base1;

sub new
{
    my $type = shift;
    my $self = {};
    print "Base1's new...\n";
    return bless $self, $type;
}

sub foo 
{ 
    print "Base1's foo...\n";
}

package Base2;

sub new
{
    my $type = shift;
    my $self = {};
    print "Base2's new...\n";
    return bless $self, $type;
}

sub foo 
{ 
    print "Base2's foo...\n"; 
}

package Derived;

@Derived::ISA = qw(Base1 Base2);

sub new
{
    my $type = shift;
    #my $self = {};
    my $self = $type->SUPER::new();
    print "Derived's new...\n";
    return bless $self, $type;
}

sub foo 
{
    my $self = shift;
    $self->SUPER::foo();
    print "Derived's foo...\n";
}

package main;

my $obj = Derived->new();
$obj->foo();

