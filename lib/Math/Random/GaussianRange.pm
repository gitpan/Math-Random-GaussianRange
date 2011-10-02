use strict;
use warnings;

package Math::Random::GaussianRange;

#ABSTRACT: Given a range, generate a set of random numbers normally distributed.

use Math::Random qw(random_normal);
use Statistics::Basic qw(median);
use Carp;
use base 'Exporter';

our @EXPORT = 'generate_normal_range';

=head2 generate_normal_range

Given a range, returns a reference to an array of randomly generated numbers
which are normally distributed i.e. clustered around the mean. The module
uses a best approximation, values are distributed within 3 standard deviations
from the perceived mean.

    my $rh = {
        min   => 0,    # minimum
        max   => 1000, # maximum
        n     => 100,  # number of numbers returned (default 100) 
        round => 0,    # return integers
    }
    
    my $ra = generate_normal_range( $rh );

=cut

sub generate_normal_range {
    my $rh    = shift;
    
    my $min   = $rh->{min};
    my $max   = $rh->{max};
    my $n     = $rh->{n} || 100;
    my $round = $rh->{round} || 0;

    unless ( defined $min && defined $max ) {
        croak "Specify a range using the min and max parameters.";
    }
    
    if ( $min > $max ) {
        croak "The minimum cannot exceeed the maximum";
    }
    
    my @range  = ( $min .. $max );
    my $median = median( @range );
    my $sd     = $median/3;

    if ( $median == 0 && $sd == 0 ) {
        carp "Median and SD are both null.";
    }

    my @output = 
        random_normal( $n, $median, $sd );
    
    if ( defined $round && $round > 0) {
        
        my $ra_rounded = [ ];
        foreach my $i ( @output ) {
            push( @$ra_rounded, sprintf('%.0f', $i) );
        }
        
        return $ra_rounded;
        
    }

    return \@output;
    
}


1;
