use strict;
use warnings;

package Horse;

sub new {
  # [x] Your Implementation Here
	my $className = shift;
	my $classInfo = {
		"_horse_index" => shift,
		"_morale" => shift,
		"_speed" => shift,
		"_experience" => shift,
		"_rank" => shift,
		"_defeated" => 0,
	};
	bless $classInfo, $className;
	return $classInfo;
}

sub get_properties {
  # [x] Your Implementation Here
	my $self = shift;
	my $properties = {
		"horse_index" => $self->{_horse_index},
		"morale" => $self->{_morale},
		"speed" => $self->{_speed},
		"experience" => $self->{_experience},
		"rank" => $self->{_rank},
		"defeated" => $self->{_defeated},
	};
	return $properties;
}

sub reduce_morale {
  # [x] Your Implementation Here
	my ($self, $damage) = @_;
	$self->{_morale} -= $damage;
	if ($self->{_morale} <= 0) {
		$self->{_morale} = 0;
		$self->{_defeated} = 1;
	}
}

sub check_defeated {
  # [x] Your Implementation Here
	my $self = shift;
	return $self->{_defeated};
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
