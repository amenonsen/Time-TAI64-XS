use strict;
use warnings;
use Test::More tests => 4;
BEGIN { use_ok 'Time::TAI64', qw( :tai :leapsecs :caltime ) }

# Perl translation of the standard C check program.
# And then made into a test program.

use Test::Differences;

my @daynames = qw( Sun Mon Tue Wed Thu Fri Sat );

ok ( leapsecs_init() == 0 => "leapsecs_init()" );

ok ( -f '/etc/leapsecs.dat' => "/etc/leapsecs.dat");

# Read in correct output
my $correct;
{
    local $/;
    undef $/;
    open (my $out, 't/check.out') or die "Cannot open check.out $!";
    $correct .= <$out>;
    close($out);
}

# Calculate output
my $output;
{
    open (my $in, 't/check.in') or die "Cannot open check.in: $!";
    while (<$in>)
    {
	if (!(my $ct = caltime_scan($_))) {
	    die "Unable to parse\n";
	} else {
	    my $t = caltime_tai($ct);
	    my ($ct2, $weekday, $yearday) = caltime_utc($t);
	    my $x = tai_pack($t);
	    my $t2 = tai_unpack($x);
	    $t2 = tai_sub($t2, $t);
	    my $packerr = tai_approx($t2);
	    my @unpacked = unpack('C8', $x);
	    $output .= sprintf "%2.2x", $_ foreach @unpacked;
	    $output .= sprintf " packerr=%f", $packerr if ($packerr);
	    $output .= sprintf(" %03d  %s %s\n",
		$yearday,
		$daynames[$weekday],
		caltime_fmt($ct2)
	    );
	}
    }
    close($in);
}

# Compare output
eq_or_diff $output => $correct => 'check.in vs computed';
