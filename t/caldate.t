use Test::More tests => 8;

BEGIN
{
	use_ok('Time::TAI64');
}

is caldate_fmt(2002,6,4) => '2002-06-04', 'Formatted positive date';
is caldate_fmt(-2002,0,2) => '-2002-00-02', 'Formatted negative date';
my $r = caldate_fmt('foo',0,2);
ok ((not defined $r), 'Erroneous input correctly generated error');
ok ((defined $Time::TAI64::ERROR and length $Time::TAI64::ERROR), 'It did indeedy');

is caldate_fmt([2002, 7, 8]) => '2002-07-08', 'Formatted with arrayref input';
my @parsed = caldate_scan('2002-07-08');
ok ( eq_array(\@parsed, [2002,7,8]), 'Parsing into array worked');
my $parsed = caldate_scan('2005-12-01');
ok ( eq_array($parsed, [2005, 12, 1]), 'Parsing into arrayref worked');
