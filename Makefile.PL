# $Id$
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		    => 'Math::NoCarry',
    'VERSION_FROM'	=> 'lib/NoCarry.pm',
	'PM'            => {
		'lib/NoCarry.pm'  => '$(INST_LIBDIR)/NoCarry.pm',
		},
);
