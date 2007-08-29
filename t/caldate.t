use strict;
use warnings;
use Test::More tests => 20;
use Data::Dumper;
BEGIN
{
	use_ok('Time::TAI64');
}

# caldate_fmt
{
		is caldate_fmt(2002,6,4) => '2002-06-04', 'Formatted positive date';
		is caldate_fmt(-2002,0,2) => '-2002-00-02', 'Formatted negative date';
		my $r = caldate_fmt('foo',0,2);
		ok ((not defined $r), 'Erroneous input correctly generated error');
		ok ((defined $Time::TAI64::ERROR and length $Time::TAI64::ERROR), 'It did indeedy');
		is caldate_fmt([2002, 7, 8]) => '2002-07-08', 'Formatted with arrayref input';
}

# caldate_scan
{ 
		my @parsed = caldate_scan('2002-07-08');
		ok ( eq_array(\@parsed, [2002,7,8]), 'Parsing into array worked');
		my $parsed = caldate_scan('2005-12-01');
		ok ( eq_array($parsed, [2005, 12, 1]), 'Parsing into arrayref worked');
}

# caldate_mjd
{
		use Time::Piece;
		my %mjd_dates = (
				0 => [ 1858, 11, 17 ],
				51604 => [ 2000, 3, 1 ],
				52345 => [ 2002, 3, 12 ],
		);
		foreach my $result (sort keys %mjd_dates)
		{
				my $mjd = caldate_mjd($mjd_dates{$result});
				is $mjd => $result, "mjd: Test for $result worked.";
				my $tp = Time::Piece->strptime(join(' ', @{$mjd_dates{$result}},0,0,0), '%Y %m %d %H %M %S');
				#is $mjd => $tp->mjd, "mjd vs TP for $result worked.";
				my @back = caldate_frommjd($result);
				ok(eq_array(\@back, $mjd_dates{$result}), "frommjd worked for $result");
		}
}

{
	my @easters = (
		[ 2001, 4, 15 ],
		[ 2002, 3, 31 ],
		[ 2003, 4, 20 ],
	);
 
	foreach my $date (@easters)
	{
		ok(eq_array($date => [caldate_easter($date->[0])]), "Easter for $date->[0]");
	}
}

# caldate_normalise
{
	my @input = (
		[[2002, 6, 2], [2002, 6, 2]],
		[[2002, 3, 32],[2002, 4, 1]],
		[[2002, 13, 32],[2003, 2, 1]],
	);
	foreach my $pair (@input)
	{
		ok(eq_array($pair->[1], [caldate_normalise(@{$pair->[0]})]), "Normalisation correct");
	}
}
