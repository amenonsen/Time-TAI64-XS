#!/usr/bin/perl -w
# Perl translation of standard yearcal C program.
# Should produce identical results.
use strict;
use Time::TAI64 qw( :caldate );

my @months = qw(
January February March April May June July
August September October November December
);

foreach my $year (@ARGV)
{
    my $cd = caldate_new($year, 1, 1);
    my $daystart = caldate_mjd($cd);
    $cd = caldate_new($year+1, 1, 1);
    my $dayend = caldate_mjd($cd);

    --$daystart while (($daystart + 3) % 7);
    ++$dayend while (($dayend + 3) % 7);

    for (my $day = $daystart; $day < $dayend; ++$day)
    {
	my ($cd, $weekday) = caldate_frommjd($day);
	if (caldate_year($cd) != $year)
	{
	    printf("   ");
	}
	else
	{
	    if (caldate_month($cd) & 1)
	    {
		if (caldate_day($cd) < 10)
		{
		    printf(" %d%c%d ",
			caldate_day($cd) % 10,
			8,
			caldate_day($cd) % 10
		    );
		}
		else
		{
		    printf("%d%c%d%d%c%d ",
			caldate_day($cd) / 10,
			8,
			caldate_day($cd) / 10,
			caldate_day($cd) % 10,
			8,
			caldate_day($cd) % 10
		    );
		}
	    }
	    else
	    {
		printf("%2d ",caldate_day($cd));
	    }
	    if ($weekday == 6) {
		if ((caldate_day($cd) >= 15) and (caldate_day($cd) < 22))
		{
		    printf(" %s %d\n", $months[caldate_month($cd) - 1], $year);
		}
		else
		{
		    printf("\n");
		}
	    }
	}
    }
    printf("\n");
}
