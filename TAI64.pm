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
our @EXPORT = qw/
    caldate_normalise caldate_easter caldate_scan caldate_fmt
    caldate_mjd caldate_frommjd tai64n tai64nlocal
/;
our ( $VERSION ) = '$Revision: 1.7 $ ' =~ /\$Revision:\s+([^\s]+)/;
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
    for ($year, $month, $day)
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
    $ERROR = '';
    if (defined $str and length $str and $str =~ /^(-?\d+)-0*(\d+)-0*(\d+)\b/)
    {
	return wantarray ? ($1,$2,$3) : (bless [$1, $2, $3], 'Time::TAI64::Caldate');
    }
    else
    {
	_fail("String does not have ISO date at start");
	return 0;
    }
}

=head2 my $mjd = caldate_mjd($year, $month, $day)

Returns the Modified Julian Day for the given date.

=cut

sub caldate_mjd
{
    my ($year,$month,$day) = (ref($_[0]) =~ /^ARRAY$|Caldate/) ? @{$_[0]} : (@_);
    $ERROR = '';
    for ($year, $month, $day)
    {
	_fail("Invalid date") unless /^-?\d+$/;
    }
    return undef if defined $ERROR and length $ERROR;
    # Valid stuff we can work with:
    my $a = int((14-$month)/12);
    my $y = $year +4800 - $a;
    my $m = $month + 12*$a -3;
    my $d = $day + int((153*$m+2)/5) + (365*$y)+int($y/4)+int($y/400)-int($y/100)-32045;
    $d -= 2_400_001;
    return $d;
}

=head2 my ($year, $month, $day) = caldate_frommjd($mjd)

Returns the year, month, day triple fo the given Modified Julian Day.

=cut

sub caldate_frommjd
{
    my $mjd = shift;
    if ($mjd =~ /^\d+$/)
    {
	my ($year, $month, $yday);
	my $day = $mjd;
	$year = int($day / 146097);
	$day %= 146097;
	$day += 678881;
	while ($day >= 146097)
	{
	    $day -= 146097;
	    $year++;
	}
	$year *= 4;
	if ($day == 146096)
	{
	    $year += 3;
	    $day = 36524;
	}
	else
	{
	    $year += int($day / 36524);
	    $day %= 36524;
	}
	$year *= 25;
	$year += int($day / 1461);
	$day %= 1461;
	$year *= 4;

	$yday = ($day < 305);
	if ($day == 1460)
	{
	    $year += 3;
	    $day = 365;
	}
	else
	{
	    $year += int($day / 365);
	    $day %= 365;
	}
	$yday += $day;

	$day *= 10;
	$month = int(($day + 5) / 306);
	$day = ($day + 5) % 306;
	$day = int($day / 10);
	if ($month >= 10)
	{
	    $yday -= 306;
	    ++$year;
	    $month -= 10;
	}
	else
	{
	    $yday += 59;
	    $month += 2;
	}
	return ($year, $month+1, $day+1);
    }
    else
    {
	_fail('Invalid modified Juloian Day');
	return undef;
    }
}

=head2 ($year, $month, $day) = caldate_normalise($year, $month, $day)

Normalises the values of year, month and day so that they are within their accepted ranges.

=cut

sub caldate_normalise
{
    caldate_frommjd(caldate_mjd(@_));
}

=head2 my ($year,$month,$day) = caldate_easter($year)

Returns the full date of Easter Sunday for the given year.

=cut

sub caldate_easter
{
    my ($y) = (@_);
    if ($y =~ /^\d+$/)
    {
	my ($month, $day);
	my ($c,$t,$j,$n);
	$c = int($y / 100) + 1;
	$t = 210 - (int(($c * 3) / 4) % 210);
	$j = $y % 19;
	$n = 57 - ((14 + $j * 11 + int(($c * 8 + 5) / 25) + $t) % 30);
	--$n if (($n == 56) && ($j > 10));
	--$n if ($n == 57);
	$n -= ((int((($y % 28) * 5) / 4) + $t + $n + 2) % 7);

	if ($n < 32) { $month = 3; $day = $n; }
	else { $month = 4; $day = $n - 31; }
	return ($y, $month, $day);
    }
  else
  {
      _fail('Invalid year passed.');
      return undef;
  }
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

    $Id: TAI64.pm,v 1.7 2002/03/12 17:54:57 koschei Exp $

=head1 ACKNOWLEDGEMENTS

DJB for writing libtai.

=head1 SEE ALSO

See L<http://cr.yp.to/time.html>

=cut
