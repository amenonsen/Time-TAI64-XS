use strict;
use Test::More tests => 1;
my $pkg = 'Time::TAI64';

# Test documentation
use Pod::Coverage;
my $pc = Pod::Coverage->new(package => $pkg);
my $c = $pc->coverage;
if (defined $c and $c == 1)
{
    pass "POD Coverage Good";
}
elsif (not defined $c)
{
    fail "POD Coverage unknown: ".$pc->why_uncovered;
}
else
{
    fail "POD Coverage inadequate: ".(join ',',$pc->naked);
}


