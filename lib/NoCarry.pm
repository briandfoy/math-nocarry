# $Id$
package Math::NoCarry;
use strict;

use base qw(Exporter);

use vars qw($VERSION);
$VERSION = sprintf "%d.%02d", q$Revision$ =~ m/ (\d+) \. (\d+) /xg;

=head1 NAME

Math::NoCarry - Perl extension for no carry arithmetic

=head1 SYNOPSIS

	use Math::NoCarry;

	my $sum        = Math::NoCarry::add( 123, 456 );

	my $difference = Math::NoCarry::subtract( 123, 456 );

	my $product    = Math::NoCarry::multiply( 123, 456 );

=head1 DESCRIPTION

No carry arithmetic doesn't allow you to carry digits to the
next column.  For example, if you add 8 and 4, you normally
expect the answer to be 12, but that 1 digit is a carry.
In no carry arithmetic you can't do that, so the sum of
8 and 4 is just 2.  In effect, this is addition modulo 10
in each column. I discard all of the carry digits in
this example:

	  1234
	+ 5678
	------
	  6802

For multiplication, the result of pair-wise multiplication
of digits is the modulo 10 value of their normal, everyday
multiplication.

        123
      x 456
      -----
          8   6 x 3
         2    6 x 2
        6     6 x 1

         5    5 x 3
        0     5 x 2
       5      5 x 1

        2     4 x 3
       8      4 x 2
    + 4       4 x 1
    -------
      43878

Since multiplication and subtraction are actually types of
additions, you can multiply and subtract like this as well.

No carry arithmetic is both associative and commutative.

=head2 Functions

This module does not export any functions.

=over 4

=item multiply( A, B )

Returns the no carry product of A and B.

Return A if it is the only argument ( A x 1 );

=cut

sub multiply
	{
	return $_[0] if $#_ < 1;

	@_ = map { $_ += 0 } @_;

	my $sign = ($_[0] > 0 and $_[1] < 0 ) ||
		($_[1] > 0 and $_[0] < 0 );

	my @p0 = reverse split //, abs $_[0];
	my @p1 = reverse split //, abs $_[1];

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

	$m[0] *= -1 if $sign;

	return $m[0];
	}

=item add( A, B )

Returns the no carry sum of the positive numbers A and B.

Returns A if it is the only argument ( A + 0 )

Returns false if either number is negative.

=cut

sub add
	{
	return $_[0] if $#_ < 1;

	@_ = map { local $^W; $_ += 0 } @_;

	return unless( $_[0] >= 0 and $_[1] >= 0 );

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

=item subtract( A, B )

Returns the no carry difference of the postive numbers A and B.

Returns A if it is the only argument ( A - 0 )

Returns false if either number is negative.

=cut

sub subtract
	{
	return $_[0] if $#_ < 1;

	return unless( $_[0] >= 0 and $_[1] >= 0);

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
	}

1;

__END__

=back

=head1 BUGS

* none reported yet :)

=head1 TO DO

* this could be a full object package with overloaded
+, *, and - operators

* it would be nice if i could give the functions more than
two arguments.

* addition and subtraction don't do negative numbers.

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT

Copyright 2002-2006, brian d foy, All Rights Reserved.

You may redistribute this under the same terms as Perl itself.

=cut
