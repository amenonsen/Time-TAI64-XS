use strict;
use warnings;
use Test::More tests => 4;
BEGIN { use_ok 'Time::TAI64', qw( :leapsecs ) }
# leapsecs_add leapsecs_sub

{
    my $s = leapsecs_read();
    if (0 == $s) {
	pass "leapsecs_read";
    } elsif ($s == -1) {
	fail 'leapsecs_read';
	diag "Problem reading /etc/leapsecs.dat file.";
    } else {
	fail 'leapsecs_read';
	diag "Invalid return code";
    }
}

for (1..2) {
    my $s = leapsecs_init();
    if (0 == $s) {
	pass "leapsecs_init ($_)"
    } elsif ($s == -1) {
	fail 'leapsecs_init';
	diag "Problem reading /etc/leapsecs.dat file.";
    } else {
	fail 'leapsecs_init';
	diag "Invalid return code";
    }
}

# leapsecs_add
# leapsecs_sub
