# $Id#
package Math::NoCarry;

require Exporter;

use vars qw($VERSION);
$VERSION = sprintf "%d.%02d", q$Revision$ =~ m/ (\d+) \. (\d+) /g;

=head1 NAME

Math::NoCarry - Perl extension for no carry arithmetic

=head1 SYNOPSIS

	use Math::NoCarry;

	my $sum     = Math::NoCarry::add( 123, 456 );
	
	my $product = Math::NoCarry::multiply( 123, 456 );
		
=head1 DESCRIPTION


=head1 FUNCTIONS

=over 4

=item multiply( A, B )

=cut

sub multiply
	{
	return $_[0] if $#_ < 1;
	
	my @p0 = reverse split //, $_[0];
	my @p1 = reverse split //, $_[1];
	
	my @m;
		
	foreach my $i ( 0 .. $#p0 )
		{		
		foreach my $j ( 0 .. $#p1 )
			{
			push @m, ( ( $p1[$j] * $p0[$i] ) % 10 ) * ( 10**($i+$j) );
			}
		}
		
	while( @m > 1 )
		{		
		unshift @m, Math::NoCarry::add( shift @m, shift @m );
		}
		
	return $m[0];	
	}

=item add( A, B )


=cut
	
sub add
	{
	return $_[0] if $#_ < 1;

	my @addends = map scalar reverse, @_;
		
	my $string = '';
	
	my $max = length $addends[0];
	$max = length $addends[1] if length $addends[1] > $max;
		
	for( my $i = 0; $i < $max ; $i++ )
		{
		my @digits = map { local $^W = 0; substr( $_, $i, 1) or 0 } @addends;
				
		my $sum = ( $digits[0] + $digits[1] ) % 10;
				
		$string .= $sum;
		}
	
	$string =~ s/0*$//;
	
	$string = scalar reverse $string;
	
	return $string;
	}

sub subtract
	{
	return $_[0] if $#_ < 1;

	my @addends = map scalar reverse, @_;
	
	my $string = '';
	
	my $max = length $addends[0];
	$max = length $addends[1] if length $addends[1] > $max;
		
	for( my $i = 0; $i < $max ; $i++ )
		{
		my @digits = map { substr $_, $i, 1 } @addends;
		
		$digits[0] += 10 if $digits[0] < $digits[1];
		
		my $sum = ( $digits[0] - $digits[1] ) % 10;
				
		$string .= $sum;
		}
		
	return scalar reverse $string;
	
	return $o;
	}
1;
__END__

=head1 AUTHOR

brian d foy, <bdfoy@cpan.org>

=cut
