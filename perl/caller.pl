#!/usr/bin/perl -w
#
# Program:  getuid.pl
# Language: Perl (UNIX environment)
#
# This program is a test to experiment with the caller() Perl library
# function.  I really just want to get the name of the currently
# executing subroutine.  This is the only straightforward way (if you
# want to call it that) I've found.
#
#==============================================================================
# Date       Programmer        Changes
# ------------------------------------------------
# 04/11/2003 Terry Nightingale Created
#
#==============================================================================

use strict;

sub main();
sub sub1();
sub sub2();

main();

sub main()
{
    my $foo = Foo->new();
    my $r = $foo->sub1();
    print "Got *$r*.\n";
}

# End main routine.

package Foo;

sub new {
    my $class = ref($_[0]) || $_[0];
    bless({}, $class);
}

sub sub1() {
    my $self = shift;

    print "Now in sub1(), calling sub2()...\n";
    my $r = $self->sub2();
    print "Back from sub2(), now leaving sub1().\n";

    return $r;
}

sub sub2() {
    my $self = shift;

    print "Now in sub2()...\n";
    print "Leaving sub2().\n";

    my $subname = (caller(0))[3];
    $subname =~ s/^.+?([^:]+$)/$1/;
    return $subname;
}

