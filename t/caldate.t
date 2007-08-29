use strict;
use warnings;
use Test::More tests => 11;
BEGIN { use_ok 'Time::TAI64', qw( :caldate ) }

{
    # Create a caldate
    my $cd = caldate_new(1982, 5, 6);
    isa_ok($cd => 'CaldatePtr');

    # Format a caldate
    my $s = caldate_fmt($cd);
    is ($s => '1982-05-06' => 'caldate_fmt');

    # Parse an ISO date
    my $dcd = caldate_scan($s);
    my $v = caldate_fmt($dcd);
    is ($v => $s, "caldate_fmt(caldate_scan(caldate_fmt(x))) equal");
}

# MJD
{
    my $cd = caldate_new(2000, 3, 1);
    my $mjd = caldate_mjd($cd);
    is ($mjd => 51604 => 'caldate_mjd for 1 Mar 2000');
    # Day number 0  is  17 November 1858.
    # Day number 51604 is 1 March 2000.
    my $newcd = caldate_frommjd(51604);
    my $v = caldate_fmt($newcd);
    my $s = caldate_fmt($cd);
    is ($v => $s, "caldate_frommjd()");
}

# Normalise
{
    my $cd = caldate_new(2000, 3, 33);
    my $newcd = caldate_normalize($cd);
    my $v = caldate_fmt($newcd);
    is ($v => '2000-04-02', "caldate_normalise()");
}

# Easter
{
    my $cd = caldate_new(2000, 1, 1);
    my $easter = caldate_easter($cd);
    my $v = caldate_fmt($easter);
    is ($v => '2000-04-23', "caldate_easter()");
}

# Accessors
{
    my $cd = caldate_new(2003, 7, 5);
    is ( caldate_day($cd) => 5 => 'caldate_day');
    is ( caldate_month($cd) => 7 => 'caldate_month');
    is ( caldate_year($cd) => 2003 => 'caldate_year');
}
