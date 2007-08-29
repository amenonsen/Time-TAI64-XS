#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 3;

BEGIN
{
    use_ok('Time::TAI64');
}

# tai64n

my %tests =
(
    '400000003c7c743a2121589c' => [1014789168, 555833500],
);

foreach (keys %tests)
{
    my $out = [tai64n($_)];
    ok eq_array($out => $tests{$_}), "tai64n times equal";
}

# tai64nlocal

my %tests_local =
(
    '400000003c7c743a2121589c' => '2002-02-27 16:52:48.555833500',
);

foreach (keys %tests_local)
{
    my $out = sprintf "%4d-%02d-%02d %02d:%02d:%02d.%09d", tai64nlocal($_);
    is $out => $tests_local{$_}, "tai64nlocal times equal"
}
