use strict;
use warnings;
use Test::More tests => 6;
BEGIN { use_ok 'Time::TAI64', qw( :tai ) }

{
    my $now = tai_now();
    ok ( tai_approx($now) > '4.61168601945712e+18' => 'now/approx' );
    my $packed = tai_pack($now);
    my $unpacked = tai_unpack($packed);
    #is ( tai_value($now) => tai_value($unpacked) => 'unpack/pack');
}

{
    my $now = tai_now();
    my $b = tai_sub($now, $now);
    my $c = tai_pack($b);
    is ( $c => "\0\0\0\0\0\0\0\0", 'now - now = 0');

    sleep 3;
    my $now2 = tai_now();
    my $a = tai_sub($now2, $now);
    my $x = tai_approx($a);
    ok ( $x >= 3, 'now2 - now = 3');

    my $now3 = tai_add($b, $now);
    my $d = tai_pack($now);
    my $e = tai_pack($now3);
    is ( $d => $e => 'adding');

    ok ( tai_less($now, $now2) => 'tai_less' );
}
