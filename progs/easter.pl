#!/usr/bin/perl -w
# Perl translation of standard Easter C program.
# Should produce identical results.
use strict;
use Time::TAI64 qw( :caldate );

my @daynames = qw( Sun Mon Tue Wed Thu Fri Sat );

foreach my $year (@ARGV)
{
    next unless $year;
    my $cd = caldate_new($year, 1, 1);
    my $mjd = caldate_mjd(caldate_easter($cd));
    my ($weekday, $yearday);
    ($cd, $weekday, $yearday) = caldate_frommjd($mjd);
    printf( "%s %s  yearday %d  mjd %d\n",
	$daynames[$weekday],
	caldate_fmt($cd),
	$yearday,
	$mjd
    );
}
