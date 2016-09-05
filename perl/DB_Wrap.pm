#
# DB_Wrap
#
# Wraps the DB_File package to provide locking of the database
#
# Copyright (c) 1999 David R. Harris
# All Rights Reserved.
#

package DB_Wrap;

use strict;
use DB_File qw();
use IO::File qw();
use Carp;

use vars qw(@ISA $store_data);

@ISA = qw( DB_File );

# # is there a better way to get these?
# sub LOCK_SH { 1 }
# sub LOCK_EX { 2 }
# sub LOCK_NB { 4 }
# sub LOCK_UN { 8 }

# Yes, there is:
use Fcntl qw(:flock);

# import function can't be inherited, so this magic required
sub import
{
	my $ourname = shift;
	my @imports = @_; # dynamic scoped var, still in scope after package call
	my $module = caller;
	my $calling = $ISA[0];
	eval " package $module; import $calling, \@imports; ";
}

sub TIEHASH
{
	my $package = shift;

	my $lock_mode;
	my ($filename, $flags, $mode, $type);

	if ( @_ == 5 ) {
		$lock_mode = pop @_;
		($filename, $flags, $mode, $type) = @_;
	} elsif ( @_ == 2 ) {
		$lock_mode = pop @_;
		($filename, $flags, $mode, $type) = @{$_[0]};
	} else {
		croak "invalid number of arguments";
	}

	$lock_mode = lc $lock_mode;
	croak "invalid lock_mode ($lock_mode)"
		if ( $lock_mode ne "read" and $lock_mode ne "write" );

	my $lockfile_name = "$filename.lock";
	my $lockfile_mode = 0600;
	$lockfile_mode |= 0040 if ( $mode | 0040 );
	$lockfile_mode |= 0004 if ( $mode | 0004 );
	my $flock_flag = lc($lock_mode) eq "write" ? LOCK_EX : LOCK_SH;

	my $lock_fh = new IO::File ("$lockfile_name", ">", $lockfile_mode)
		or croak "could not open lockfile ($lockfile_name)";

	flock $lock_fh, $flock_flag
		or croak "could not flock lockfile";

	my $self = $package->SUPER::TIEHASH(@_);

	# RRR the object is not a hash, so we can't just add keys to it, so we
	# have to store what we want to store elsewhere. We extract the memory
	# address of the scalar this reference points to and use that as our
        # key to a package global hash where we store the info.

	my $id = "" . $self;
	$id =~ s/^[^=]+=//; # remove the package name in case re-blessing occurs

	$store_data->{$id} = 
	{
		lock_fh   => $lock_fh,
		lock_mode => $lock_mode,
	};

	return $self;
}

sub DESTROY
{
	my $self = shift;

	my $id = "" . $self;
	$id =~ s/^[^=]+=//;

	my $lock_fh   = $store_data->{$id}{lock_fh};
	my $lock_mode = $store_data->{$id}{lock_mode};
	delete $store_data->{$id};

	$self->SUPER::DESTROY(@_);

	flock $lock_fh, LOCK_UN;
	$lock_fh->close;
}

1;
