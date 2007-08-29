package Time::TAI64;

=head1 NAME

Time::TAI64 - support for Temps Atomique International

=head1 SYNOPSIS

    use Time::TAI64;
   
    printf "%4d-%02d-%02d %02d:%02d:%02d.%09d\n",
	tai64nlocal('400000003c7c743a2121589c');

=head1 DESCRIPTION

This module provides support for the hiresolution and somewhat long
lasting TAI time format. It's 64 bit and goes down to nanoseconds. At
least, the TAI64N format does while TAI64 just goes to seconds.

This module provides a routine to convert from TAI back to a usable form.
It will provide more functions as I get time to do things with them.

It's in XS since the operation to perform the conversion is not one of
Perl's forte's and is really quite slow (well, my somewhat straight
conversion from C to Perl performed quite badly). Other versions,
including pure Perl, are provided in the benchmarks directory in the
module distribution.

=cut

require 5.006;
use strict;
use warnings;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

our %EXPORT_TAGS = ( );
our @EXPORT_OK = ( );
our @EXPORT = qw( caldate_scan caldate_fmt tai64n tai64nlocal );
our ( $VERSION ) = '$Revision: 1.6 $ ' =~ /\$Revision:\s+([^\s]+)/;
our $ERROR;

sub _fail
{
    $ERROR = shift;
    return undef;
}

bootstrap Time::TAI64 $VERSION;

=head1 FUNCTIONS

=head2 my $str = caldate_fmt($year, $month, $day)

Given a year, month and day it returns an ISO formatted string
representation of that date.

=cut

sub caldate_fmt
{
    my ($year,$month,$day) = (ref($_[0]) =~ /^ARRAY$|Caldate/) ? @{$_[0]} : (@_);
    $ERROR = '';
    for ($year, $month, $year)
    {
	_fail("Invalid date") unless /^-?\d+$/;
    }
    return undef if defined $ERROR and length $ERROR;
    return sprintf("%s%d-%02d-%02d", (($year < 0) ? "-" : ""),abs($year),$month,$day);
}

=head2 my ($year, $month, $day) = caldate_scan($str)

Given an ISO formatted string, or a string started with an ISO formatted
date, ithis function returns the year, month and day. If used within a
scalar context, it returns an arrayref of the elements (as a
Time::TAI64::Caldate object).

=cut

sub caldate_scan
{
    my $str = $_[0];
    return 0 unless defined $str and length $str;
    return 0 unless $str =~ /^(-?\d+)-0*(\d+)-0*(\d+)\b/;
    return wantarray ? ($1,$2,$3) : (bless [$1, $2, $3], 'Time::TAI64::Caldate');
}

=head2 my ($secs, $nano) = tai64n($time)

Takes a 24 hex-digit number as input and returns the seconds and
nanoseconds the time represents. Seconds are standard Unix style.

=head2 my @time = tai64nlocal($time)

Takes a 24 hex-digit number as input and returns the year, month, day,
hour, min, sec and nanosecs that the number represents. All numbers are
normalised (i.e. it will return 1998, not 98; and January is 1, not 0).

=cut

1;
__END__
#
# ========================================================================
#                                                Rest Of The Documentation

=head1 AUTHOR

Iain Truskett <spoon@cpan.org> L<http://eh.org/~koschei/>

Please report any bugs, or post any suggestions, to either the mailing
list at <cpan@dellah.anu.edu.au> (email
<cpan-subscribe@dellah.anu.edu.au> to subscribe) or directly to the
author at <spoon@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2002 Iain Truskett. All rights reserved. This program is
free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

    $Id: TAI64.pm,v 1.6 2002/03/11 17:11:19 koschei Exp $

=head1 ACKNOWLEDGEMENTS

DJB for writing libtai.

=head1 SEE ALSO

See L<http://cr.yp.to/time.html>

=cut
