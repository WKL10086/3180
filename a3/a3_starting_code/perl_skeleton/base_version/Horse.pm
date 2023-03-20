use strict;
use warnings;

package Horse;

sub new {
  # Your Implementation Here
}

sub get_properties {
  # Your Implementation Here
}

sub reduce_morale {
  # Your Implementation Here
}

sub check_defeated {
  # Your Implementation Here
}

sub print_info {
	my $self = shift;

	my $defeated_info;
	if ($self -> check_defeated() == 1) {
		$defeated_info = "defeated";
	} else {
		$defeated_info = "undefeated";
	}
	print "Horse ", $self->{_horse_index}, ": morale: ", $self->{_morale}, " speed: ", $self->{_speed}, " experience: ", $self->{_experience}, " rank: ", $self->{_rank}, " ", $defeated_info, "\n";
}


1;
