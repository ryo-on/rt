# BEGIN LICENSE BLOCK
# 
# Copyright (c) 1996-2003 Jesse Vincent <jesse@bestpractical.com>
# 
# (Except where explictly superceded by other copyright notices)
# 
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from www.gnu.org.
# 
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# Unless otherwise specified, all modifications, corrections or
# extensions to this work which alter its source code become the
# property of Best Practical Solutions, LLC when submitted for
# inclusion in the work.
# 
# 
# END LICENSE BLOCK
=head1 NAME

  RT::Transactions - a collection of RT Transaction objects

=head1 SYNOPSIS

  use RT::Transactions;


=head1 DESCRIPTION


=head1 METHODS

=begin testing

ok (require RT::Transactions);

=end testing

=cut

use strict;
no warnings qw(redefine);

# {{{ sub _Init  
sub _Init   {
  my $self = shift;
  
  $self->{'table'} = "Transactions";
  $self->{'primary_key'} = "id";
  
  # By default, order by the date of the transaction, rather than ID.
  $self->OrderBy( ALIAS => 'main',
		  FIELD => 'Created',
		  ORDER => 'ASC');

  return ( $self->SUPER::_Init(@_));
}
# }}}

# {{{ sub Next
sub Next {
    my $self = shift;
 	
    my $Transaction = $self->SUPER::Next();
    if ((defined($Transaction)) and (ref($Transaction))) {
    	# If the user can see the transaction's type, then they can 
	#  see the transaction and we should hand it back.
	if ($Transaction->Type) {
	    return($Transaction);
	}

	#If the user doesn't have the right to show this ticket
	else {	
	    return($self->Next());
	}
    }

    #if there never was any ticket
    else {
	return(undef);
    }	
}
# }}}



1;

