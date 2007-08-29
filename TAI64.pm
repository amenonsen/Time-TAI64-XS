package Time::TAI64;

use 5.008;
use strict;
use warnings;
use Carp;

=head1 NAME

Time::TAI64 - a library for storing and manipulating dates and times.

=head1 SYNOPSIS

    use Time::TAI64 qw( :caldate :caltime :tai :leapsecs :taia );
    use Time::TAI64 qw( :all );

=cut

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 
    'caldate' => [qw/
	caldate_new caldate_fmt caldate_scan caldate_mjd
	caldate_frommjd caldate_normalize caldate_easter
	caldate_day caldate_month caldate_year
    / ],
    'caltime' => [qw/
	caltime_tai caltime_utc caltime_fmt caltime_scan
	caltime_offset caltime_second caltime_minute
	caltime_hour caltime_date
    / ],
    'tai' => [qw/
	tai_now tai_approx tai_add tai_sub tai_less
	tai_pack tai_unpack
    / ],
    'leapsecs' => [qw/
	leapsecs_init leapsecs_read leapsecs_add leapsecs_sub
    / ],
    'taia' => [qw/
	taia_tai taia_now taia_approx taia_frac taia_add taia_sub
	taia_half taia_less taia_pack taia_unpack taia_fmtfrac
    / ],
);
$EXPORT_TAGS{'all'} = [ map { (@{$_}) } values %EXPORT_TAGS ];

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ();

our $VERSION = '1.8';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Time::TAI64::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	*$AUTOLOAD = sub { $val };
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Time::TAI64', $VERSION);

1;
__END__

=head1 DESCRIPTION


NOTE: THIS IS AN EXPERIMENTAL VERSION. THE USER INTERFACE B<WILL> CHANGE
AND IT WILL CHANGE B<DRASTICALLY>. PLEASE WAIT UNTIL VERSION 1.9 BEFORE
USING THIS MODULE.

ALSO, A LOT OF THE CODE WILL CHANGE. SO, DON'T RELY ON ANYTHING IN THIS
MODULE BEING THE SAME IN TWO WEEKS. OH, AND THE DOCUMENTATION WILL BE
DRASTICALLY IMPROVED.

THAT SAID, TEST FAILURES WOULD BE APPRECIATED =)


Time::TAI64 is a library for storing and manipulating dates and times.

Time::TAI64 supports two time scales:

=over 4

=item 1

TAI64, covering a few hundred billion years with 1-second precision

=item 2

TAI64NA, covering the same period with 1-attosecond precision. Both
scales are defined in terms of TAI, the current international real time
standard.

=back

Time::TAI64 provides an internal format for TAI64, C<TAIPtr>, designed
for fast time manipulations. The tai_pack() and tai_unpack() routines
convert between struct tai and a portable 8-byte TAI64 storage format.
Time::TAI64 provides similar internal and external formats for TAI64NA
(C<TAIAPtr>).

Time::TAI64 provides C<CaldatePtr> to store dates in year-month-day
form. It can convert C<CaldatePtr>, under the Gregorian calendar, to a
modified Julian day number for easy date arithmetic.

Time::TAI64 provides C<CaltimePtr> to store calendar dates and times
along with UTC offsets. It can convert from C<TAIPtr> to C<CaltimePtr>
in UTC, accounting for leap seconds, for accurate date and time display.
It can also convert back from C<CaltimePtr> to C<TAIPtr> for user input.
Its overall UTC-to-TAI conversion speed is 100x better than the usual
UNIX mktime() implementation.

This version of Time::TAI64 requires a UNIX system with gettimeofday().
It will be easy to port to other operating systems with compilers
supporting 64-bit arithmetic.

=head1 OBJECT ORIENTED INTERFACE

The preferred way of using this library is through objects. You don't
have to though since the complete complement of functions is available
via various export groups. See the L<FUNCTIONS> section for more detail.

XXX

=head1 FUNCTIONS

There's quite a few functions. 41 all up (unless I miscounted).
This section is divided into the export groups.

I will warn you, up front, that your code will end up over long if you
stick to using functions. Each data object produced by this module that
is not a simple integer or string is an opaque object and you will
B<need> to use accessors to use its attributes. Thus, the OO interface
is generally recommended.

=head2 :caldate

=over 4

=item caldate_new

=item caldate_fmt

=item caldate_scan

=item caldate_mjd

=item caldate_frommjd

=item caldate_normalize

=item caldate_easter

=item caldate_day

=item caldate_month

=item caldate_year

=back

=head2 :caltime

=over 4

=item caltime_tai

=item caltime_utc

=item caltime_fmt

=item caltime_scan

=item caltime_offset

=item caltime_second

=item caltime_minute

=item caltime_hour

=item caltime_date

=back

=head2 :tai

=over 4

=item tai_now

=item tai_approx

=item tai_add

=item tai_sub

=item tai_less

=item tai_pack

=item tai_unpack

=back

=head2 :leapsecs

=over 4

=item leapsecs_init

=item leapsecs_read

=item leapsecs_add

=item leapsecs_sub

=back

=head2 :taia

=over 4

=item taia_tai

=item taia_now

=item taia_approx

=item taia_frac

=item taia_add

=item taia_sub

=item taia_half

=item taia_less

=item taia_pack

=item taia_unpack

=item taia_fmtfrac

=back

=cut

#
# ========================================================================
#                                                Rest Of The Documentation

=head1 AUTHOR

Iain Truskett E<lt>spoon@cpan.orgE<gt> L<http://eh.org/~koschei/>

Please report any bugs to L<http://rt.cpan.org/> or email them
(and/or suggestions to me directly at E<lt>spoon@cpan.orgE<gt>

=head1 COPYRIGHT

XS and Perl code copyright (c) 2002 Iain Truskett. All rights reserved.
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

C source files derived from F<qlogtools>, copyright 2000 Bruce Guenter.
Those derived from libtai are public domain. Those from daemontools
are copyright 2001 D J Bernstein.

=head1 ACKNOWLEDGEMENTS

DJB for writing libtai and daemontools. Bruce Guenter for qlogtools.

=head1 SEE ALSO

See L<http://cr.yp.to/time.html>, L<http://untroubled.org/qlogtools/>

=cut
