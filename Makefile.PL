use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME		=> 'Time::TAI64',
    VERSION_FROM	=> 'TAI64.pm',
    PREREQ_PM => {
		'Pod::Coverage' => 0.11,
		'Module::Info' => 0.12,
		'Test::More' => 0.42,
		'Time::Piece' => 1.01,
		'DynaLoader' => 1.04,
		'Data::Dumper' => 2.102,
		'Exporter' => 5.562,
	    },
    'LIBS'              => [''],
    'DEFINE'            => '',
    'INC'               => '',
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'TAI64.pm', # retrieve abstract from module
      AUTHOR     => 'Iain Truskett <spoon@cpan.org>') : ()),
);


