#!/usr/bin/perl -w
# Perl translation of standard Leapsecs C program.
# Should produce identical results.
# Doesn't not currently work due to breakage in encapsulation.
use strict;
use Time::TAI64 qw( :tai :leapsecs :caldate );

my $leaps = 0;

while (<>)
{
    if (s/^\+//)
    {
	if ( my $cd = caldate_scan($_) )
	{
	    # Breaks encapsulation - doesn't currently work like that.
	    my $mjd = caldate_mjd($cd);
	    my $t{x} = ($mjd + 1) * 86400 + 4611686014920671114 + $leaps++;
	    my $x = tai_pack($t);
	    print $x;
	}
    }
}
