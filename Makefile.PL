# $Id$
use ExtUtils::MakeMaker;

require 5.006;

eval "use Test::Manifest 1.14";

WriteMakefile
	(
	'NAME'         => 'Math::NoCarry',
	'ABSTRACT'     => 'Perl extension for no carry arithmetic',
	'VERSION_FROM' => 'lib/NoCarry.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',
	
	'PM'             => {
		'lib/NoCarry.pm'    => '$(INST_LIBDIR)/NoCarry.pm',
		},

	'PREREQ_PM' => {
		'Test::More'       => '0',
		},

	'MAN3PODS'     => {
		'lib/NoCarry.pm' => '$(INST_MAN3DIR)/Math::NoCarry.3',
		},

	clean => { FILES => 'Math-NoCarry-*' },
	);
