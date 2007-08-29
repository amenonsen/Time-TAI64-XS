use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Time::TAI64',
    'VERSION_FROM'	=> 'TAI64.pm',
    'PREREQ_PM'		=> {
	    'Test::Differences'	=> 0.45,
	    'Test::More'	=> 0.41,
    },
    ($] >= 5.005 ?
      (AUTHOR     => 'Iain Truskett <spoon@cpan.org>') : ()),
    'LIBS'		=> [''],
    'MYEXTLIB' => '',
    'MYEXTLIB'		=> 'tai_add.o tai_now.o tai_pack.o '.
	'tai_sub.o tai_unpack.o taia_add.o taia_approx.o '.
	'taia_fmtfrac.o taia_frac.o taia_half.o taia_less.o '.
	'taia_now.o taia_pack.o taia_sub.o taia_tai.o taia_unpack.o '.
	'caldate_fmt.o caldate_scan.o caldate_fmjd.o caldate_mjd.o '.
	'caldate_norm.o caldate_ster.o leapsecs_read.o '.
	'leapsecs_init.o leapsecs_add.o leapsecs_sub.o caltime_fmt.o '.
	'caltime_scan.o caltime_tai.o caltime_utc.o '.
	'tai_encode.o tai_decode.o tai64n_encode.o tai64n_decode.o ',
    'CCFLAGS'		=> '-Wall',
    'DEFINE'		=> '',
    'INC'		=> '-I.',
#    'dist'		=> {
#	    COMPRESS => 'bzip2',
#	    SUFFIX => '.bz2',
#	},
);
if  (eval {require ExtUtils::Constant; 1}) {
  # If you edit these definitions to change the constants used by this module,
  # you will need to use the generated const-c.inc and const-xs.inc
  # files to replace their "fallback" counterparts before distributing your
  # changes.
  my @names = (qw());
  ExtUtils::Constant::WriteConstants(
                                     NAME         => 'Time::TAI64',
                                     NAMES        => \@names,
                                     DEFAULT_TYPE => 'IV',
                                     C_FILE       => 'const-c.inc',
                                     XS_FILE      => 'const-xs.inc',
                                  );

}
else {
  use File::Copy;
  use File::Spec;
  foreach my $file ('const-c.inc', 'const-xs.inc') {
    my $fallback = File::Spec->catfile('fallback', $file);
    copy ($fallback, $file) or die "Can't copy $fallback to $file: $!";
  }
}
