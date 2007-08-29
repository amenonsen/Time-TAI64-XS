#!/usr/bin/perl -w
# Perl translation of the standard C check program.
# Should produce identical result.
use strict;
use Time::TAI64 qw( :tai :leapsecs :caltime );

my @daynames = qw( Sun Mon Tue Wed Thu Fri Sat );

printf("unable to init leapsecs\n") if (leapsecs_init() == -1);

while (<>)
{
    if (!(my $ct = caltime_scan($_))) {
	printf "Unable to parse\n";
    } else {
	my $t = caltime_tai($ct);
	my ($ct2, $weekday, $yearday) = caltime_utc($t);
	my $x = tai_pack($t);
	my $t2 = tai_unpack($x);
	$t2 = tai_sub($t2, $t);
	my $packerr = tai_approx($t2);
	my @unpacked = unpack('C8', $x);
	printf "%2.2x", $_ foreach @unpacked;
	printf " packerr=%f", $packerr if ($packerr);
	printf " %03d  %s", $yearday, $daynames[$weekday];
	printf " %s", caltime_fmt($ct2);
	printf "\n";
    }
}
