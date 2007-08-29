#!/usr/bin/perl -w
# Perl translation of standard NowUTC C program.
# Should produce identical results.
use strict;
use Time::TAI64 qw/ :leapsecs :tai :taia :caltime :caldate /;

if (leapsecs_init() == -1) {
    warn "$0 fatal: unable to init leapsecs\n";
    exit 111;
}
    
my $now = taia_now();
my $x = taia_fmtfrac($now);
my $sec = taia_tai($now);
my $ct = caltime_utc($sec);

printf("%d-%02d-%02d %02d:%02d:%02d.%s\n"
    ,caldate_year(caltime_date($ct))
    ,caldate_month(caltime_date($ct))
    ,caldate_day(caltime_date($ct))
    ,caltime_hour($ct)
    ,caltime_minute($ct)
    ,caltime_second($ct)
    ,$x
);
