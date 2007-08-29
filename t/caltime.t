use strict;
use warnings;
use Test::More tests => 11;
BEGIN { use_ok 'Time::TAI64', qw( :caldate :caltime :tai ) }

{
    my $fmt = 'yyyy-mm-dd hh:mm:ss +oooo';
    my $s   = '2002-08-20 02:04:03 +1000';
    # Parse an ISO date
    my $dcd = caltime_scan($s);
    my $v = caltime_fmt($dcd);
    is ($v => $s, "caltime_fmt(caltime_scan(caltime_fmt(x))) equal");
    my $now = tai_now();
    my $n = caltime_utc($now);
    my $u = caltime_fmt($n);
    ok ($u gt $v => 'caltime_fmt/caltime_utc');
}

{
    my $t = tai_now();
    my $m = tai_pack($t);

    my $ct = caltime_utc($t);
    my $u = caltime_tai($ct);
    my $n = tai_pack($u);

    is ($m => $n, 'caltime_utc -> caltime_tai');
}

# Accessors
{
    my $s   = '1970-04-14 07:01:34 +0900';
    my $ct = caltime_scan($s);

    is (caltime_offset($ct) => 540 => 'caltime_offset($ct)');
    is (caltime_second($ct) => 34 => 'caltime_second($ct)');
    is (caltime_minute($ct) => 1 => 'caltime_minute($ct)');
    is (caltime_hour($ct) => 7 => 'caltime_hour($ct)');
    my $cd = caltime_date($ct);
    is ( caldate_day($cd) => 14 => 'caldate_day');
    is ( caldate_month($cd) => 4 => 'caldate_month');
    is ( caldate_year($cd) => 1970 => 'caldate_year');
}
