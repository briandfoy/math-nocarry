# $Id$
use ExtUtils::MakeMaker;

eval "use Test::Manifest";

unless( $@ )
	{
	sub ExtUtils::MM_Any::test_via_harness
		{
		my($self, $perl, $tests) = @_;

		return qq|\t$perl "-MTest::Manifest" | .
			qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
			qq|'\$(INST_ARCHLIB)')"\n|;
		}
	}

WriteMakefile
	(
	'NAME'           => 'Math::NoCarry',
	'VERSION_FROM'   => 'lib/NoCarry.pm',
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
